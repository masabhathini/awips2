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
package com.raytheon.uf.common.dataplugin.warning.config;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.text.ParsePosition;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.measure.unit.NonSI;
import javax.measure.unit.Unit;
import javax.measure.unit.UnitFormat;
import javax.xml.bind.JAXBException;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

import com.raytheon.uf.common.dataplugin.warning.WarningRecord.WarningAction;
import com.raytheon.uf.common.dataplugin.warning.config.AreaSourceConfiguration.AreaType;
import com.raytheon.uf.common.dataplugin.warning.util.FileUtil;
import com.raytheon.uf.common.serialization.ISerializableObject;
import com.raytheon.uf.common.serialization.SerializationUtil;
import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;
import com.raytheon.uf.common.status.UFStatus.Priority;

/**
 * WarngenConfiguration
 * 
 * <pre>
 * 
 *    SOFTWARE HISTORY
 *   
 *    Date         Ticket#     Engineer    Description
 *    ------------ ----------  ----------- --------------------------
 *    Nov 21, 2007             chammack    Initial Creation.
 *    Aug 26, 2008 #1502       bclement    Added JAXB annotations
 *    May 26, 2010 #4649       Qinglu Lin  Made including TO.A and SV.A mandatory
 * 
 * </pre>
 * 
 * @author chammack
 * @version 1
 */
@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "warngenConfig")
public class WarngenConfiguration implements ISerializableObject {
    private static final transient IUFStatusHandler statusHandler = UFStatus
            .getHandler(WarngenConfiguration.class);

    private static Pattern p = Pattern
            .compile("<\\s{0,}include\\s{1,}file\\s{0,}=\\s{0,}\"(.*)\"\\s{0,}/>");

    @XmlElement
    private GeospatialConfiguration geospatialConfig;

    @XmlElement
    private PathcastConfiguration pathcastConfig;

    @XmlElement
    private AreaConfiguration areaConfig;

    @XmlElementWrapper(name = "bulletActionGroups")
    @XmlElement(name = "bulletActionGroup")
    private BulletActionGroup[] bulletActionGroups;

    private Bullet[] bullets;

    private DamInfoBullet[] damInfoBullets;

    @XmlElementWrapper(name = "includedWatches")
    @XmlElement(name = "includedWatch")
    private String[] includedWatches;

    @XmlElementWrapper(name = "durations")
    @XmlElement(name = "duration")
    private int[] durations;

    @XmlElementWrapper(name = "followups")
    @XmlElement(name = "followup")
    private String[] followUps;

    @XmlElementWrapper(name = "maps")
    @XmlElement(name = "map")
    private String[] maps = new String[0];

    private Unit<?> unitDistance = NonSI.MILE;

    private Unit<?> unitSpeed = NonSI.MILES_PER_HOUR;

    @XmlElement
    private boolean trackEnabled = true;

    @XmlElement(name = "defaultDuration")
    private int defaultDuration;

    @XmlElement(name = "enableDuration")
    private boolean enableDuration = true;

    @XmlElement(name = "enableRestart")
    private boolean enableRestart;

    @XmlElement(name = "enableDamBreakThreat")
    private boolean enableDamBreakThreat;

    @XmlElement(name = "autoLockText")
    private boolean autoLockText;

    @XmlElementWrapper(name = "phensigs")
    @XmlElement(name = "phensig")
    private String[] phensigs;

    @XmlElement(name = "pointSource")
    private PointSourceConfiguration[] pointSources;

    @XmlElement(name = "areaSource")
    private AreaSourceConfiguration[] areaSources;

    @XmlElement(name = "lockedGroupsOnFollowup")
    private String lockedGroupsOnFollowup;

    /**
     * Method used to load a configuration file for a newly selected Warngen
     * template.
     * 
     * @param templateName
     *            - the name of the warngen template
     * @return the warngen configuration
     * @throws VizException
     */
    public static WarngenConfiguration loadConfig(String templateName,
            String localSite) throws FileNotFoundException, IOException,
            JAXBException {
        WarngenConfiguration config = new WarngenConfiguration();

        // Open the template file
        String xml = FileUtil.open(templateName + ".xml", localSite);

        // Include external files, such as damInfo.txt
        Matcher m = p.matcher(xml);
        String includeFile = null;
        try {
            while (m.find()) {
                includeFile = m.group(1);
                String includeXml = FileUtil.open(includeFile, localSite);
                xml = xml.replace(m.group(0), includeXml);
            }
        } catch (Exception e) {
            statusHandler.handle(Priority.PROBLEM,
                    "Error occurred trying to include " + includeFile
                            + " in template " + templateName, e);
        }

        config = (WarngenConfiguration) SerializationUtil.unmarshalFromXml(xml);

        // Sets the lists of bullets and dam bullets
        if (config.getBulletActionGroups() != null) {
            for (BulletActionGroup group : config.getBulletActionGroups()) {
                if (group.getAction() == null
                        || WarningAction.valueOf(group.getAction()) == WarningAction.NEW) {
                    config.setBullets(group.getBullets());
                    config.setDamInfoBullets(group.getDamInfoBullets());
                    break;
                }
            }
        }

        PointSourceConfiguration pscs[] = config.getPointSources();

        if (pscs != null) {
            for (PointSourceConfiguration psc : pscs) {
                if (psc.getPointSource() == null) {
                    psc.setPointSource(config.getGeospatialConfig()
                            .getPointSource());
                }
            }
        }

        List<AreaSourceConfiguration> ascList = new ArrayList<AreaSourceConfiguration>();
        if (config.getAreaConfig() != null) {
            AreaSourceConfiguration areaSourceConfig = new AreaSourceConfiguration(
                    config.getAreaConfig());
            ascList.add(areaSourceConfig);
        }

        AreaSourceConfiguration ascs[] = config.getAreaSources();
        if (ascs != null) {
            ascList.addAll(Arrays.asList(ascs));
        }

        for (AreaSourceConfiguration asc : ascList) {
            if (asc.getAreaSource() == null) {
                asc.setAreaSource(config.getGeospatialConfig().getAreaSource());
            }

            if (asc.getAreaType() == AreaType.HATCHING) {
                config.setAreaConfig(asc.getAreaConfig());
            }
        }

        config.setAreaSources(ascList
                .toArray(new AreaSourceConfiguration[ascList.size()]));

        if (config.getPathcastConfig() != null
                && config.getPathcastConfig().getPointSource() == null) {
            config.getPathcastConfig().setPointSource(
                    config.getGeospatialConfig().getPointSource());
        }

        return config;
    }

    public String[] getMaps() {
        return maps;
    }

    public void setMaps(String[] maps) {
        this.maps = maps;
    }

    /**
     * @return the areaConfig
     */
    public AreaConfiguration getAreaConfig() {
        return areaConfig;
    }

    /**
     * @param areaConfig
     *            the areaConfig to set
     */
    public void setAreaConfig(AreaConfiguration areaConfig) {
        this.areaConfig = areaConfig;
    }

    /**
     * @return the geospatialConfig
     */
    public GeospatialConfiguration getGeospatialConfig() {
        return geospatialConfig;
    }

    /**
     * @param geospatialConfig
     *            the geospatialConfig to set
     */
    public void setGeospatialConfig(GeospatialConfiguration geospatialConfig) {
        this.geospatialConfig = geospatialConfig;
    }

    /**
     * @return the pathcastConfig
     */
    public PathcastConfiguration getPathcastConfig() {
        return pathcastConfig;
    }

    /**
     * @param pathcastConfig
     *            the pathcastConfig to set
     */
    public void setPathcastConfig(PathcastConfiguration pathcastConfig) {
        this.pathcastConfig = pathcastConfig;
    }

    /**
     * @return the bullets
     */
    public Bullet[] getBullets() {
        return bullets;
    }

    /**
     * @param bullets
     *            the bullets to set
     */
    public void setBullets(Bullet[] bullets) {
        this.bullets = bullets;
    }

    public BulletActionGroup[] getBulletActionGroups() {
        return bulletActionGroups;
    }

    public void setBulletActionGroups(BulletActionGroup[] bulletActionGroups) {
        this.bulletActionGroups = bulletActionGroups;
    }

    public DamInfoBullet[] getDamInfoBullets() {
        return damInfoBullets;
    }

    public void setDamInfoBullets(DamInfoBullet[] damInfoBullets) {
        this.damInfoBullets = damInfoBullets;
    }

    /**
     * @return the durations
     */
    public int[] getDurations() {
        return durations;
    }

    /**
     * @param durations
     *            the durations to set
     */
    public void setDurations(int[] durations) {
        this.durations = durations;
    }

    public int getDefaultDuration() {
        return defaultDuration;
    }

    public void setDefaultDuration(int defaultDuration) {
        this.defaultDuration = defaultDuration;
    }

    public String[] getFollowUps() {
        return followUps;
    }

    public void setFollowUps(String[] followUps) {
        this.followUps = followUps;
    }

    /**
     * @param phensigs
     *            the phensigs to set
     */
    public void setPhensigs(String[] phensigs) {
        this.phensigs = phensigs;
    }

    /**
     * @return the phensigs
     */
    public String[] getPhensigs() {
        return phensigs;
    }

    public void setIncludedWatches(String[] includedWatches) {
        this.includedWatches = includedWatches;
    }

    public String[] getIncludedWatches() {
        return includedWatches;
    }

    public boolean getEnableRestart() {
        return enableRestart;
    }

    public void setEnableRestart(boolean enableRestart) {
        this.enableRestart = enableRestart;
    }

    public boolean getEnableDamBreakThreat() {
        return enableDamBreakThreat;
    }

    public void setEnableDamBreakThreat(boolean enableDamBreakThreat) {
        this.enableDamBreakThreat = enableDamBreakThreat;
    }

    public boolean getAutoLockText() {
        return autoLockText;
    }

    public void setAutoLockText(boolean autoLockText) {
        this.autoLockText = autoLockText;
    }

    public Unit<?> getUnitDistance() {
        return unitDistance;
    }

    public void setUnitDistance(Unit<?> unitDistance) {
        this.unitDistance = unitDistance;
    }

    public Unit<?> getUnitSpeed() {
        return unitSpeed;
    }

    public void setUnitSpeed(Unit<?> unitSpeed) {
        this.unitSpeed = unitSpeed;
    }

    public String setUnitDistanceString() {
        return UnitFormat.getUCUMInstance().format(this.unitDistance);
    }

    @XmlElement(name = "unitDistance")
    public void setUnitDistanceString(String unitDistance) {
        try {
            this.unitDistance = (Unit<?>) UnitFormat.getUCUMInstance()
                    .parseProductUnit(unitDistance, new ParsePosition(0));
        } catch (ParseException e) {
            throw new RuntimeException("Error setting unit speed: "
                    + e.getLocalizedMessage(), e);
        }
    }

    public String getUnitSpeedString() {
        return UnitFormat.getUCUMInstance().format(this.unitSpeed);
    }

    @XmlElement(name = "unitSpeed")
    public void setUnitSpeedString(String unitSpeed) {
        try {
            this.unitSpeed = (Unit<?>) UnitFormat.getUCUMInstance()
                    .parseProductUnit(unitSpeed, new ParsePosition(0));
        } catch (ParseException e) {
            throw new RuntimeException("Error setting unit speed: "
                    + e.getLocalizedMessage(), e);
        }
    }

    public PointSourceConfiguration[] getPointSources() {
        return pointSources;
    }

    public void setPointSources(PointSourceConfiguration[] pointSources) {
        this.pointSources = pointSources;
    }

    public AreaSourceConfiguration[] getAreaSources() {
        return areaSources;
    }

    public void setAreaSources(AreaSourceConfiguration[] areaSources) {
        this.areaSources = areaSources;
    }

    public boolean isTrackEnabled() {
        return trackEnabled;
    }

    public void setTrackEnabled(boolean trackEnabled) {
        this.trackEnabled = trackEnabled;
    }

    public String getLockedGroupsOnFollowup() {
        return lockedGroupsOnFollowup;
    }

    public void setLockedGroupsOnFollowup(String lockedGroupsOnFollowup) {
        this.lockedGroupsOnFollowup = lockedGroupsOnFollowup;
    }

    public boolean isEnableDuration() {
        return enableDuration;
    }

    public void setEnableDuration(boolean enableDuration) {
        this.enableDuration = enableDuration;
    }

}
