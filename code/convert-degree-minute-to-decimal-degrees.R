
## Script to convert degree minute seconds to decimal degrees
## Please refer to this stack overflow link for more details:https://stackoverflow.com/questions/14404596/converting-geo-coordinates-from-degree-to-decimal

x = read.table(text = "
latitude	longitude
11°24.281  76°55.589
11°23.515	 76°51.767
11°24.737	 76°53.581
11°23.047  76°55.461
11°23.447	 76°55.409
11°22.889	 76°55.261
11°20.877	76°56.586
11°21.273	76°56.461
11°24.009	76°55.963
11°23.817	76°55.582
11°24.774	76°47.093
11°20.283	76°54.065
11°20.476	76°51.071
11°24.634	76°53.253
11°23.807	76°54.466
11°26.119	76°52.541
",header = TRUE, stringsAsFactors = FALSE)

# change the degree symbol to a space
x$latitude = gsub('°', ' ', x$latitude)
x$longitude = gsub('°', ' ', x$longitude)

# convert from decimal minutes to decimal degrees
x$latitude = measurements::conv_unit(x$latitude, 
                                     from = 'deg_dec_min', 
                                     to = 'dec_deg')
x$longitude = measurements::conv_unit(x$longitude, 
                                      from = 'deg_dec_min', 
                                      to = 'dec_deg')

write.csv(x, "C:\\Users\\vr292\\Downloads\\dms.csv")
