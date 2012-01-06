package com.raytheon.viz.volumebrowser.xml;

import java.util.List;

import javax.xml.bind.JAXB;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.raytheon.uf.common.localization.FileUpdatedMessage;
import com.raytheon.uf.common.localization.ILocalizationFileObserver;
import com.raytheon.uf.common.localization.LocalizationFile;
import com.raytheon.uf.common.localization.PathManagerFactory;
import com.raytheon.uf.common.serialization.ISerializableObject;
import com.raytheon.uf.viz.core.exception.VizException;

/**
 * 
 * TODO Add Description
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Jan 6, 2011            bsteffen     Initial creation
 * 
 * </pre>
 * 
 * @author bsteffen
 * @version 1.0
 */
@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement
public class VbSourceList implements ISerializableObject {

    private final static String VB_SOURCE_FILE = "volumebrowser/VbSources.xml";

    private static class VbSourceListener implements ILocalizationFileObserver {

        /*
         * (non-Javadoc)
         * 
         * @see
         * com.raytheon.uf.common.localization.ILocalizationFileObserver#fileUpdated
         * (com.raytheon.uf.common.localization.FileUpdatedMessage)
         */
        @Override
        public void fileUpdated(FileUpdatedMessage message) {
            synchronized (VB_SOURCE_FILE) {
                instance = null;
            }
        }

    }

    private static ILocalizationFileObserver observer = null;

    private static VbSourceList instance;

    @XmlElement(name = "vbSource")
    private List<VbSource> entries;

    /**
     * @return the entries
     */
    public List<VbSource> getEntries() {
        return entries;
    }

    /**
     * @param entries
     *            the entries to set
     */
    public void setEntries(List<VbSource> entries) {
        this.entries = entries;
    }

    public static VbSourceList getInstance() throws VizException {
        synchronized (VB_SOURCE_FILE) {
            if (instance == null) {
                LocalizationFile file = PathManagerFactory.getPathManager()
                        .getStaticLocalizationFile(VB_SOURCE_FILE);
                if (observer == null) {
                    observer = new VbSourceListener();
                    file.addFileUpdatedObserver(observer);
                }

                instance = JAXB.unmarshal(file.getFile(), VbSourceList.class);

            }
            return instance;
        }
    }
}
