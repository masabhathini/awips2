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
package com.raytheon.uf.common.dataplugin.shef.tables;

// Generated Oct 17, 2008 2:22:17 PM by Hibernate Tools 3.2.2.GA

import java.util.Date;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import com.raytheon.uf.common.dataplugin.persist.PersistableDataObject;
import com.raytheon.uf.common.serialization.annotations.DynamicSerialize;
import com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement;

/**
 * Dspradar generated by hbm2java
 *
 *
 * <pre>
 *
 * SOFTWARE HISTORY
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Oct 17, 2008                        Initial generation by hbm2java
 * Aug 19, 2011 10672      jkorman     Move refactor to new project
 * Oct 07, 2013 2361       njensen     Removed XML annotations
 * Nov 21, 2016 5588       nabowle     Cleanup.
 * Jul 25, 2018 5588       mapeters    Added NamedQueries annotation
 *
 * </pre>
 *
 * @author jkorman
 */
@NamedQueries({
        @NamedQuery(name = Dspradar.SELECT_BY_RAD_ID_BETWEEN_OBS_TIME, query = Dspradar.SELECT_BY_RAD_ID_BETWEEN_OBS_TIME_HQL) })
@Entity
@Table(name = "dspradar")
@DynamicSerialize
public class Dspradar extends PersistableDataObject<DspradarId>
        implements IGriddedRadarRecord {

    private static final long serialVersionUID = 1L;

    public static final String SELECT_BY_RAD_ID_BETWEEN_OBS_TIME = "selectDSPRadarByRadIdBetweenObsTime";

    protected static final String SELECT_BY_RAD_ID_BETWEEN_OBS_TIME_HQL = "FROM Dspradar r WHERE r.id.radid = :radid AND r.id.obstime >= :startObsTime AND r.id.obstime <= :endObsTime";

    @DynamicSerializeElement
    private DspradarId id;

    @DynamicSerializeElement
    private Radarloc radarloc;

    @DynamicSerializeElement
    private Short volcovpat;

    @DynamicSerializeElement
    private Short opermode;

    @DynamicSerializeElement
    private Float minval;

    @DynamicSerializeElement
    private Float maxval;

    @DynamicSerializeElement
    private Float numDataLev;

    @DynamicSerializeElement
    private Float scaleFactor;

    @DynamicSerializeElement
    private Date beginTime;

    @DynamicSerializeElement
    private Date endTime;

    @DynamicSerializeElement
    private Short JBegDate;

    @DynamicSerializeElement
    private Short JBegTime;

    @DynamicSerializeElement
    private Short JEndDate;

    @DynamicSerializeElement
    private Short JEndTime;

    @DynamicSerializeElement
    private Short meanFieldBias;

    @DynamicSerializeElement
    private Short sampleSize;

    @DynamicSerializeElement
    private String gridFilename;

    public Dspradar() {
    }

    public Dspradar(DspradarId id, Radarloc radarloc) {
        this.id = id;
        this.radarloc = radarloc;
    }

    public Dspradar(DspradarId id, Radarloc radarloc, Short volcovpat,
            Short opermode, Float minval, Float maxval, Float numDataLev,
            Float scaleFactor, Date beginTime, Date endTime, Short JBegDate,
            Short JBegTime, Short JEndDate, Short JEndTime, Short meanFieldBias,
            Short sampleSize, String gridFilename) {
        this.id = id;
        this.radarloc = radarloc;
        this.volcovpat = volcovpat;
        this.opermode = opermode;
        this.minval = minval;
        this.maxval = maxval;
        this.numDataLev = numDataLev;
        this.scaleFactor = scaleFactor;
        this.beginTime = beginTime;
        this.endTime = endTime;
        this.JBegDate = JBegDate;
        this.JBegTime = JBegTime;
        this.JEndDate = JEndDate;
        this.JEndTime = JEndTime;
        this.meanFieldBias = meanFieldBias;
        this.sampleSize = sampleSize;
        this.gridFilename = gridFilename;
    }

    @EmbeddedId
    @AttributeOverrides({
            @AttributeOverride(name = "radid", column = @Column(name = "radid", nullable = false, length = 3)),
            @AttributeOverride(name = "obstime", column = @Column(name = "obstime", nullable = false, length = 29)) })
    public DspradarId getId() {
        return this.id;
    }

    public void setId(DspradarId id) {
        this.id = id;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "radid", nullable = false, insertable = false, updatable = false)
    public Radarloc getRadarloc() {
        return this.radarloc;
    }

    public void setRadarloc(Radarloc radarloc) {
        this.radarloc = radarloc;
    }

    @Column(name = "volcovpat")
    public Short getVolcovpat() {
        return this.volcovpat;
    }

    public void setVolcovpat(Short volcovpat) {
        this.volcovpat = volcovpat;
    }

    @Column(name = "opermode")
    public Short getOpermode() {
        return this.opermode;
    }

    public void setOpermode(Short opermode) {
        this.opermode = opermode;
    }

    @Column(name = "minval", precision = 8, scale = 8)
    public Float getMinval() {
        return this.minval;
    }

    public void setMinval(Float minval) {
        this.minval = minval;
    }

    @Column(name = "maxval", precision = 8, scale = 8)
    public Float getMaxval() {
        return this.maxval;
    }

    public void setMaxval(Float maxval) {
        this.maxval = maxval;
    }

    @Column(name = "num_data_lev", precision = 8, scale = 8)
    public Float getNumDataLev() {
        return this.numDataLev;
    }

    public void setNumDataLev(Float numDataLev) {
        this.numDataLev = numDataLev;
    }

    @Column(name = "scale_factor", precision = 8, scale = 8)
    public Float getScaleFactor() {
        return this.scaleFactor;
    }

    public void setScaleFactor(Float scaleFactor) {
        this.scaleFactor = scaleFactor;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "begin_time", length = 29)
    public Date getBeginTime() {
        return this.beginTime;
    }

    public void setBeginTime(Date beginTime) {
        this.beginTime = beginTime;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "end_time", length = 29)
    public Date getEndTime() {
        return this.endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    @Column(name = "j_beg_date")
    public Short getJBegDate() {
        return this.JBegDate;
    }

    public void setJBegDate(Short JBegDate) {
        this.JBegDate = JBegDate;
    }

    @Column(name = "j_beg_time")
    public Short getJBegTime() {
        return this.JBegTime;
    }

    public void setJBegTime(Short JBegTime) {
        this.JBegTime = JBegTime;
    }

    @Column(name = "j_end_date")
    public Short getJEndDate() {
        return this.JEndDate;
    }

    public void setJEndDate(Short JEndDate) {
        this.JEndDate = JEndDate;
    }

    @Column(name = "j_end_time")
    public Short getJEndTime() {
        return this.JEndTime;
    }

    public void setJEndTime(Short JEndTime) {
        this.JEndTime = JEndTime;
    }

    @Override
    @Column(name = "mean_field_bias")
    public Short getMeanFieldBias() {
        return this.meanFieldBias;
    }

    public void setMeanFieldBias(Short meanFieldBias) {
        this.meanFieldBias = meanFieldBias;
    }

    @Column(name = "sample_size")
    public Short getSampleSize() {
        return this.sampleSize;
    }

    public void setSampleSize(Short sampleSize) {
        this.sampleSize = sampleSize;
    }

    @Override
    @Column(name = "grid_filename", length = 20)
    public String getGridFilename() {
        return this.gridFilename;
    }

    public void setGridFilename(String gridFilename) {
        this.gridFilename = gridFilename;
    }

    @Transient
    @Override
    public Date getObsTime() {
        return id.getObstime();
    }

}
