package gov.noaa.nws.ncep.metparameters;


	import javax.measure.unit.Unit;

import gov.noaa.nws.ncep.metParameters.parameterConversion.PRLibrary;
	import gov.noaa.nws.ncep.metparameters.MetParameterFactory.DeriveMethod;

import com.raytheon.uf.common.dataplugin.IDecoderGettable.Amount;

	public class PressChange3Hr extends AbstractMetParameter implements 
	javax.measure.quantity.Pressure {
		public PressChange3Hr() {
			 super( UNIT );
		}

 	}

	


