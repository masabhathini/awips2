/**
 * This software was developed and / or modified by Raytheon Company,
 * pursuant to Contract DG133W-05-CQ-1067 with the US Government.
 * 
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * This software product contains export-restricted data whose
 * export/transfer/disclosure is restricted by U.S. law. Dissemination
 * to non-U.S. persons whether in the United States or abroad requires
 * an export license or other authorization.
 * 
 * Contractor Name:        Raytheon Company
 * Contractor Address:     6825 Pine Street, Suite 340
 *                         Mail Stop B8
 *                         Omaha, NE 68106
 *                         402.291.0100
 * 
 * See the AWIPS II Master Rights File ("Master Rights File.pdf") for
 * further licensing information.
 **/
package com.raytheon.viz.gfe.perspective;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.core.commands.Command;
import org.eclipse.core.commands.CommandManager;
import org.eclipse.core.commands.Parameterization;
import org.eclipse.core.commands.ParameterizedCommand;
import org.eclipse.core.commands.contexts.ContextManager;
import org.eclipse.jface.action.ContributionItem;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.bindings.Binding;
import org.eclipse.jface.bindings.BindingManager;
import org.eclipse.jface.bindings.Scheme;
import org.eclipse.jface.bindings.keys.KeyBinding;
import org.eclipse.jface.bindings.keys.KeySequence;
import org.eclipse.jface.bindings.keys.KeyStroke;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IEditorReference;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.commands.ICommandService;
import org.eclipse.ui.keys.IBindingService;

import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;
import com.raytheon.uf.common.status.UFStatus.Priority;
import com.raytheon.uf.viz.core.IDisplayPane;
import com.raytheon.uf.viz.core.IDisplayPaneContainer;
import com.raytheon.uf.viz.core.IExtent;
import com.raytheon.uf.viz.core.PixelExtent;
import com.raytheon.uf.viz.core.drawables.IRenderableDisplay;
import com.raytheon.uf.viz.core.drawables.ResourcePair;
import com.raytheon.uf.viz.core.exception.VizException;
import com.raytheon.uf.viz.core.map.IMapDescriptor;
import com.raytheon.uf.viz.core.maps.MapManager;
import com.raytheon.viz.gfe.Activator;
import com.raytheon.viz.gfe.PythonPreferenceStore;
import com.raytheon.viz.gfe.actions.FormatterlauncherAction;
import com.raytheon.viz.gfe.core.DataManager;
import com.raytheon.viz.gfe.core.GFEMapRenderableDisplay;
import com.raytheon.viz.gfe.core.ISpatialDisplayManager;
import com.raytheon.viz.gfe.core.internal.GFESpatialDisplayManager;
import com.raytheon.viz.gfe.procedures.ProcedureJob;
import com.raytheon.viz.gfe.rsc.GFELegendResourceData;
import com.raytheon.viz.gfe.smarttool.script.SmartToolJob;
import com.raytheon.viz.gfe.statusline.ISCSendEnable;
import com.raytheon.viz.ui.EditorUtil;
import com.raytheon.viz.ui.cmenu.ZoomMenuAction;
import com.raytheon.viz.ui.editor.AbstractEditor;
import com.raytheon.viz.ui.perspectives.AbstractCAVEPerspectiveManager;
import com.raytheon.viz.ui.perspectives.VizPerspectiveListener;

/**
 * Manages the life cycle of the GFE Perspectives
 * 
 * Installs a perspective watcher that handles the transitions in and out of the
 * GFE perspectives.
 * 
 * <pre>
 * SOFTWARE HISTORY
 * Date			Ticket#		Engineer	Description
 * ------------	----------	-----------	--------------------------
 * Jul 17, 2008		#1223	randerso	Initial creation
 * Oct 6, 2008      #1433   chammack    Removed gfe status bars
 * Apr 9, 2009       1288   rjpeter     Added saving of the renderable display.
 * Jun 11, 2009     #1947   rjpeter     Moved parm save hook to GridManagerView.
 * Apr 27, 2010             mschenke    refactor for common perspective switching
 * Jul 7, 2011      #9897   ryu         close formatters on perspective close/reset
 * </pre>
 * 
 * @author randerso
 * @version 1.0
 */

public class GFEPerspectiveManager extends AbstractCAVEPerspectiveManager {
    private static final transient IUFStatusHandler statusHandler = UFStatus
            .getHandler(GFEPerspectiveManager.class);

    /** The GFE Perspective Class */
    public static final String GFE_PERSPECTIVE = "com.raytheon.viz.ui.GFEPerspective";

    public GFEPerspectiveManager() {

    }

    @Override
    public void open() {
        loadDefaultBundle("gfe/default-procedure.xml");

        AbstractEditor gfeEditor = (AbstractEditor) EditorUtil
                .getActiveEditor();
        // Disable closing on the active editor
        gfeEditor
                .disableClose("The Map Editor cannot be closed in the GFE Perspective");

        IDisplayPane pane = gfeEditor.getActiveDisplayPane();

        PythonPreferenceStore prefs = Activator.getDefault()
                .getPreferenceStore();
        String[] maps = prefs.getStringArray("MapBackgrounds_default");

        MapManager mapMgr = MapManager.getInstance((IMapDescriptor) pane
                .getDescriptor());

        for (String map : maps) {
            mapMgr.loadMapByBundleName(map);
        }

        defineKeys();

        DataManager dm = DataManager.getInstance(perspectiveWindow);
        IRenderableDisplay display = pane.getRenderableDisplay();
        if (display instanceof GFEMapRenderableDisplay) {
            ((GFEMapRenderableDisplay) display).setDataManager(dm);
        }
        // Add GFE Legend
        try {
            ResourcePair legend = ResourcePair
                    .constructSystemResourcePair(new GFELegendResourceData(dm));
            legend.instantiateResource(pane.getDescriptor(), true);
            pane.getDescriptor().getResourceList().add(legend);
        } catch (VizException e) {
            statusHandler
                    .handle(Priority.PROBLEM, "Error adding GFE Legend", e);
        }

        if (dm != null) {
            ISpatialDisplayManager mgr = dm.getSpatialDisplayManager();

            if (mgr instanceof GFESpatialDisplayManager) {
                try {
                    ((GFESpatialDisplayManager) mgr).populate(gfeEditor);
                } catch (Throwable e) {
                    statusHandler.handle(Priority.PROBLEM,
                            "Populating the map with GFE data has failed.", e);
                }
            } else {
                throw new IllegalStateException(this.getClass().getName()
                        + " must be used with "
                        + GFESpatialDisplayManager.class.getName());
            }
        }

        DataManager.fireChangeListener();
    }

    @Override
    public void activate() {
        super.activate();

        DataManager.fireChangeListener();

        // Hack to disable editor closing
        IWorkbenchPage activePage = perspectiveWindow.getActivePage();
        if (activePage != null) {
            for (IEditorReference ref : activePage.getEditorReferences()) {
                IEditorPart part = ref.getEditor(true);
                if (part instanceof AbstractEditor) {
                    AbstractEditor editor = (AbstractEditor) part;
                    editor.disableClose("The Map Editor cannot be closed in the GFE Perspective");
                }
            }
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * com.raytheon.viz.ui.perspectives.AbstractCAVEPerspectiveManager#getTitle
     * (java.lang.String)
     */
    @Override
    protected String getTitle(String title) {
        String config = Activator.getDefault().getPreferenceStore()
                .getConfigName();
        String gfeTitle = super.getTitle(title);
        gfeTitle += "(" + config + ")";
        return gfeTitle;
    }

    @Override
    public void close() {
        super.close();

        try {
            DataManager dm = DataManager.findInstance(perspectiveWindow);
            if (dm != null) {
                ISpatialDisplayManager mgr = dm.getSpatialDisplayManager();
                if (mgr instanceof GFESpatialDisplayManager) {
                    ((GFESpatialDisplayManager) mgr).depopulate();
                } else {
                    throw new IllegalStateException(this.getClass().getName()
                            + " must be used with "
                            + GFESpatialDisplayManager.class.getName());
                }
            }
        } catch (Throwable e) {
            statusHandler.handle(Priority.PROBLEM,
                    "Depopulating the GFE resources from the map has failed.",
                    e);
        }

        DataManager.dispose(perspectiveWindow);

        // Put on own thread so close is not slowed down.
        new Thread(new Runnable() {

            @Override
            public void run() {
                ProcedureJob.shutdown();
                SmartToolJob.shutdown();
            }
        }).start();
        if (FormatterlauncherAction.getFormatterLauncher() != null)
            FormatterlauncherAction.getFormatterLauncher().closeFormatters();
    }

    @Override
    public void deactivate() {
        super.deactivate();
        if (IWorkbenchPage.CHANGE_RESET.equals(VizPerspectiveListener
                .getInstance().getPerspectiveChangeId(
                        GFEPerspective.ID_PERSPECTIVE))) {
            if (FormatterlauncherAction.getFormatterLauncher() != null)
                FormatterlauncherAction.getFormatterLauncher()
                        .closeFormatters();
        }
    }

    @Override
    protected List<ContributionItem> getStatusLineItems() {
        List<ContributionItem> items = super.getStatusLineItems();
        items.add(new ISCSendEnable());
        return items;
    }

    private void defineKeys() {
        ICommandService commandService = (ICommandService) PlatformUI
                .getWorkbench().getService(ICommandService.class);

        CommandManager commandManager = new CommandManager();

        ContextManager contextManager = new ContextManager();

        IBindingService bindingService = (IBindingService) PlatformUI
                .getWorkbench().getAdapter(IBindingService.class);

        Scheme activeScheme = bindingService.getActiveScheme();
        String schemeId = activeScheme.getId();

        BindingManager bindingManager = new BindingManager(contextManager,
                commandManager);
        PythonPreferenceStore prefs = Activator.getDefault()
                .getPreferenceStore();
        try {
            Scheme scheme = bindingManager.getScheme(schemeId);
            scheme.define(activeScheme.getName(),
                    activeScheme.getDescription(), activeScheme.getParentId());

            // get currentBindings and remove any GFE ShortCut bindings
            String contextId = "com.raytheon.viz.gfe.GFEShortCutContext";
            Binding[] currentBindings = bindingService.getBindings();
            List<Binding> newBindings = new ArrayList<Binding>();
            for (Binding binding : currentBindings) {
                if (!binding.getContextId().equals(contextId)) {
                    newBindings.add(binding);
                }
            }
            bindingManager.setBindings(newBindings
                    .toArray(new Binding[newBindings.size()]));

            for (int i = 1; i < 201; i++) {
                String shortCut = "ShortCut" + i;
                String[] keyDef = prefs.getStringArray(shortCut);
                if (keyDef != null && keyDef.length > 0) {
                    if (keyDef.length != 4) {
                        statusHandler
                                .handle(Priority.PROBLEM,
                                        "Invalid GFE ShortCut definition "
                                                + shortCut
                                                + ": definition should contain 4 strings");
                        continue;
                    }

                    String key;
                    if (keyDef[1].isEmpty()
                            || keyDef[1].equalsIgnoreCase("None")) {
                        key = keyDef[0].toUpperCase();
                    } else if (keyDef[1].equalsIgnoreCase("Ctl")) {
                        key = "CTRL" + KeyStroke.KEY_DELIMITER
                                + keyDef[0].toUpperCase();
                    } else {
                        key = keyDef[1].toUpperCase() + KeyStroke.KEY_DELIMITER
                                + keyDef[0].toUpperCase();
                    }
                    KeyStroke keyStroke;
                    try {
                        keyStroke = KeyStroke.getInstance(key);
                    } catch (Exception e) {
                        statusHandler.handle(Priority.PROBLEM,
                                "Invalid GFE ShortCut definition " + shortCut
                                        + ": " + e.getLocalizedMessage());
                        continue;
                    }
                    KeySequence keySequence = KeySequence
                            .getInstance(new KeyStroke[] { keyStroke });

                    Command command = null;
                    Parameterization[] parms = null;
                    if (keyDef[2].equals("SmartTool")) {
                        command = commandService
                                .getCommand("com.raytheon.viz.gfe.actions.RunSmartToolAction");
                        parms = new Parameterization[] { new Parameterization(
                                command.getParameter("name"), keyDef[3]) };
                    } else if (keyDef[2].equals("Procedure")) {
                        command = commandService
                                .getCommand("com.raytheon.viz.gfe.actions.RunProcedureAction");
                        parms = new Parameterization[] { new Parameterization(
                                command.getParameter("name"), keyDef[3]) };
                    } else if (keyDef[2].equals("EditTool")) {
                        String commandId = null;
                        if (keyDef[3].equals("Sample")) {
                            commandId = "com.raytheon.viz.gfe.editTools.sample";
                        } else if (keyDef[3].equals("Pencil")) {
                            commandId = "com.raytheon.viz.gfe.editTools.pencil";
                        } else if (keyDef[3].equals("Contour")) {
                            commandId = "com.raytheon.viz.gfe.editTools.contour";
                        } else if (keyDef[3].equals("MoveCopy")) {
                            commandId = "com.raytheon.viz.gfe.editTools.moveCopy";
                        } else if (keyDef[3].equals("DrawEditArea")) {
                            commandId = "com.raytheon.viz.gfe.editTools.selectPoints";
                        } else {
                            statusHandler.handle(Priority.PROBLEM,
                                    "Invalid GFE ShortCut definition "
                                            + shortCut + ": " + keyDef[3]
                                            + " is not a valid EditTool");
                            continue;
                        }
                        command = commandService.getCommand(commandId);
                    } else if (keyDef[2].equals("Toggle")) {
                        String commandId = null;
                        if (keyDef[3].equals("ISC")) {
                            commandId = "com.raytheon.viz.gfe.actions.showISCGrids";
                        } else if (keyDef[3].equals("TEGM")) {
                            commandId = "com.raytheon.viz.gfe.actions.toggleTemporalEditor";
                        } else {
                            statusHandler.handle(Priority.PROBLEM,
                                    "Invalid GFE ShortCut definition "
                                            + shortCut + ": " + keyDef[3]
                                            + " is not a valid Toggle");
                            continue;
                        }
                        command = commandService.getCommand(commandId);
                    } else {
                        statusHandler.handle(Priority.PROBLEM,
                                "Invalid GFE ShortCut definition " + shortCut
                                        + ": " + keyDef[2]
                                        + " is not a valid Action");
                        continue;
                    }
                    ParameterizedCommand parmCmd = new ParameterizedCommand(
                            command, parms);

                    // add the binding
                    bindingManager.addBinding(new KeyBinding(keySequence,
                            parmCmd, schemeId, contextId, null, null, null,
                            Binding.USER));
                }
            }
            bindingService.savePreferences(bindingManager.getScheme(schemeId),
                    bindingManager.getBindings());
        } catch (Throwable e) {
            statusHandler.handle(Priority.PROBLEM, e.getLocalizedMessage(), e);
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * com.raytheon.viz.ui.AbstractVizPerspective#addContextMenuItems(org.eclipse
     * .jface.action.IMenuManager, com.raytheon.viz.core.IDisplayPaneContainer,
     * com.raytheon.viz.core.IDisplayPane)
     */
    @Override
    public void addContextMenuItems(IMenuManager menuManager,
            IDisplayPaneContainer container, IDisplayPane pane) {
        super.addContextMenuItems(menuManager, container, pane);

        DataManager dataManager = DataManager.getCurrentInstance();
        if (dataManager != null) {
            // Don't add menu items for the resource if mouse is in the colorbar

            // code for corrected mouse X and Y copied from
            // GFEColorbarResource
            IDisplayPane displayPane = container.getActiveDisplayPane();
            int x = displayPane.getLastClickX();
            int y = displayPane.getLastClickY();
            org.eclipse.swt.graphics.Rectangle bounds = displayPane.getBounds();
            IExtent extent = displayPane.getRenderableDisplay().getExtent();
            double correctedX = x * (extent.getMaxX() - extent.getMinX())
                    / bounds.width + extent.getMinX();
            double correctedY = y * (extent.getMaxY() - extent.getMinY())
                    / bounds.height + extent.getMinY();

            PixelExtent colorBarExtent = dataManager.getSpatialDisplayManager()
                    .getColorbarExtent();
            if (colorBarExtent != null
                    && colorBarExtent.contains(correctedX, correctedY)) {
                return;
            }
        }
        menuManager.add(new ZoomMenuAction(container));
    }
}
