	
*-- Running R from Stata 	
	
	** We start in Stata 
	sysuse auto.dta, clear
	
	** Switch to R 
	rsource, terminator(END_OF_R) rpath("/usr/local/bin/R") roptions(`"--vanilla"')
	
	library(epidata)
	library(foreign)
	packageVersion("epidata")
	d <- get_productivity_and_hourly_compensation()
	d$comp_1979 <- (d$growth_since_1948_average_compensation/1.200) - 1 
	names(d)[names(d)=="date"] <- "year"
	names(d)[names(d)=="growth_since_1948_net_productivity_per_hour_worked"] <- "produc_1948"
	names(d)[names(d)=="growth_since_1948_average_compensation"] <- "comp_1948"
	names(d)[names(d)=="growth_since_1948_average_compensation_of_production_and_nonsupervisory_workers"] <- "comp_pnsu_1948"
	names(d)[names(d)=="average_compensation_of_production_and_nonsupervisory_workers"] <- "average_comp_pnsup"
	write.dta(d, "mydata.dta")
		
	END_OF_R	
	
	** And back to Stata 
	use "mydata.dta", clear
	line produc_1948 year, title("Productivity growth since 1948") lcolor(red) xtitle("") ytitle("") scheme(s1mono)
	graph export "product.png", as(png) fontface(garamond) replace 	
	
	erase "mydata.dta"
	
