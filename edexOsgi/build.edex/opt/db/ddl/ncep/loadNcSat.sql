-- load sat.channel tables

COPY sat.channel (channel_strings, num) FROM stdin;
Visible             	1
0.58-0.68 micron VIS	1
0.55-0.75 micron VIS	1
0.6 micron visible	1
3.9 micron         	2
3.9 micron IR       	2
3.90 micron IR    	2
3.80-4.00 micron IR	2
6.50-7.00 micron IR 	2
6.7 micron          	4
6.7 micron water vapor	4
10.20-11.20 micron IR	8
11 micron IR        	8
10.50-11.50 micron IR 	8
11 micron           	8
12 micron          	16
12 micron IR        	16
\.

COPY sat.imgcoeffs (satellite_id, satellite_num, channel, det, scal_coef_m, scal_coef_b, side, conv_coef_n, conv_coef_a, conv_coef_b, conv_coef_g) FROM stdin;
GOES8	70	2	1	227.3889	68.2167	1	2556.71	-0.618007	1.001825	-6.021442e-07
GOES8	70	2	2	227.3889	68.2167	1	2558.62	-0.668648	1.002221	-1.323758e-06
GOES8	70	3	0	38.8383	29.1287	1	1481.91	-0.656443	1.001914	-9.535221e-07
GOES8	70	4	1	5.2285	15.6854	1	934.30	-0.519333	1.002834	-3.005194e-06
GOES8	70	4	2	5.2285	15.6854	1	935.38	-0.553431	1.002894	-3.077855e-06
GOES8	70	5	1	5.0273	15.3332	1	837.06	-0.383077	1.000856	6.026892e-07
GOES8	70	5	2	5.0273	15.3332	1	837.00	-0.351510	1.000340	1.761416e-06
GOES9	72	2	1	227.3889	68.2167	1	2555.18	-0.592268	1.001040	-1.882973e-07
GOES9	72	2	2	227.3889	68.2167	1	2555.18	-0.592268	1.001040	-1.882973e-07
GOES9	72	3	0	38.8383	29.1287	1	1481.82	-0.559306	1.001602	-1.010812e-06
GOES9	72	4	1	5.2285	15.6854	1	934.59	-0.525515	1.002411	-2.148433e-06
GOES9	72	4	2	5.2285	15.6854	1	934.28	-0.532929	1.002616	-2.584012e-06
GOES9	72	5	1	5.0273	15.3332	1	834.02	-0.317704	1.001058	-2.245684e-07
GOES9	72	5	2	5.0273	15.3332	1	834.09	-0.346344	1.001261	-6.031501e-07
GOES10	74	2	1	227.3889	68.2167	2	2552.9845	-0.63343694	1.0013206	-4.2038547e-07
GOES10	74	2	2	227.3889	68.2167	2	2552.9845	-0.63343694	1.0013206	-4.2038547e-07
GOES10	74	3	0	38.8383	29.1287	2	1486.2212	-0.66500842	1.0017857	-7.3885254e-07
GOES10	74	4	1	5.2285	15.6854	2	936.10260	-0.36939128	1.0017466	-1.4981835e-06
GOES10	74	4	2	5.2285	15.6854	2	935.98981	-0.41013697	1.0020766	-2.1303556e-06
GOES10	74	5	1	5.0273	15.3332	2	830.88473	-0.32763317	1.0014057	-9.5563444e-07
GOES10	74	5	2	5.0273	15.3332	2	830.89691	-0.32184480	1.0013828	-9.3581045e-07
GOES11	76	2	1	227.3889	68.2167	1	2562.07	-0.651377	1.000828	-1.002675e-07
GOES11	76	2	2	227.3889	68.2167	1	2562.07	-0.651377	1.000828	-1.002675e-07
GOES11	76	3	0	38.8383	29.1287	1	1481.53	-0.620175	1.002104	-1.171163e-06
GOES11	76	4	1	5.2285	15.6854	1	931.76	-0.546157	1.003175	-3.656323e-06
GOES11	76	4	2	5.2285	15.6854	1	931.76	-0.546157	1.003175	-3.656323e-06
GOES11	76	5	1	5.0273	15.3332	1	833.67	-0.329940	1.000974	5.000439e-08
GOES11	76	5	2	5.0273	15.3332	1	833.04	-0.307032	1.000903	1.233306e-07
GOES12	78	2	1	227.3889	68.2167	1	2562.45	-0.727744	1.002131	-1.173898e-06
GOES12	78	2	2	227.3889	68.2167	1	2562.45	-0.727744	1.002131	-1.173898e-06
GOES12	78	3	1	38.8383	29.1287	1	1536.43	-5.278975	1.016476	-7.754348e-06
GOES12	78	3	2	5.2285	15.6854	1	1536.94	-5.280110	1.016383	-7.607900e-06
GOES12	78	4	1	5.2285	15.6854	1	933.21	-0.534982	1.002693	-2.667092e-06
GOES12	78	4	2	5.0273	15.3332	1	933.21	-0.534982	1.002693	-2.667092e-06
GOES12	78	6	0	5.5297	16.5892	1	751.91	-0.177244	1.000138	1.163496e-06
\.

