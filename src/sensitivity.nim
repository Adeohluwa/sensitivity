#!/usr/bin/env nimcr
#nimcr-argc c -r --threads:on

import nimx/[window,slider,layout,button,text_field]

#define ESS constants
let dod = 0.8
let cycles = 6000.0
let capex = 100.0
let size = 1.0
let tarriff = 0.08
let discount = 10.0
let interest_rates = @[0.05, 0.10, 0.15, 0.20, 0.25]


#define PV constants       in watts,hrs,yrs
let sizePV = 1.0           
let pv = 0.12
let inverter = 0.25
let eol = 15.0
let peakSunHrs = 4.0
let capital_costs = @[0.05, 0.10, 0.15, 0.20, 0.25]

proc calculateLCOE(sizePV,pv,inverter,eol, discount: float): float =
    let capitalCosts = sizePV*(pv+inverter) 
    let totalGeneration = sizePV*0.001*peakSunHrs*365*eol
    result = capitalCosts/totalGeneration

proc calculateLCOS(dod,cycles,capex,size, discount: float): float =
    result = capex/(dod*cycles*size)

# GUI
runApplication:
  var w = newWindow(newRect(50,50,500,150))
  w.title = "Battery LCOS"


  w.makeLayout:
    - Label as greetingLabel:
        center == super
        width == 300
        height == 15
        text: "Welcome to the Sensitivity Analysis App"


    - TextField:
      width == 200
      height == 25
      top  == prev.bottom + 2

    - TextField:
      width == 200
      height == 25
      top  == prev.bottom + 4
    
    - TextField:
      width == 200
      height == 25
      top  == prev.bottom + 6
    
    - TextField:
      width == 200
      height == 25
      top  == prev.bottom + 8

    - Slider:
      width == 500
      height == 15
      #top  == 

    - Button:
      centerX == super
      bottom  == prev.bottom + 100
      width == 200
      height == 25
      title: "Calculate Sensitivity"
      onAction:
        #echo 2
        let lcoePV = calculateLCOE(sizePV,pv,inverter,eol,discount)
        let lcoeESS = calculateLCOS(dod,cycles,capex,size,discount)
        echo "LCOE for Solar PV is ",$lcoePV
        echo "LCOS for Battery ESS is ",$lcoeESS
        echo "Total is ",$(lcoePV + lcoeESS)

