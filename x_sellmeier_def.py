
import numpy as np
from scipy.constants import c 

def sellmeiercore(wlcol):

    ncorecol = np.sqrt(1 + 0.708395 * wlcol**2/(wlcol)**2 - 0.00729) + 0.420399 * wlcol**2/(wlcol**2 - 0.01050) + 0.866341 * wlcol**2/(wlcol**2 - 97.93428)

    polyfitwln = np.polyfit(wlcol,ncorecol,3)
    dpolyfitwln = np.polyder(polyfitwln) # derivate
    dndwlcol = np.polyval(dpolyfitwln,wlcol) # get

    Ncorecol = ncorecol - wlcol * (dndwlcol)
    
    polyfitdndwl = np.polyfit(wlcol, dndwlcol, 3) # fitting by 3rd order
    dpolyfitdndwl = np.polyder(polyfitdndwl) # derivate
    ddnddwlcol = np.polyval(dpolyfitdndwl, wlcol)# get
    
    scorecol = wlcol**2 * ddnddwlcol
  
    return ncorecol, Ncorecol, scorecol

def sellmeierclad(wlcol): # wavelength in um
   
   ncladcol =  np.sqrt(1 + 0.696 * wlcol**2/(wlcol)**2 - 0.004368) + 0.408 * wlcol**2/(wlcol**2 - 0.01395) + 0.896 * wlcol**2/(wlcol**2 - 97.93)
   
   polyfitwln = np.polyfit(wlcol,ncladcol,3)
   dpolyfitwln = np.polyder(polyfitwln) # derivate
   dndwlcol = np.polyval(dpolyfitwln,wlcol) # get
   
   Ncladcol = ncladcol - wlcol * (dndwlcol)
   
   polyfitdndwl = np.polyfit(wlcol, dndwlcol, 3) # fitting by 3rd order
   dpolyfitdndwl = np.polyder(polyfitdndwl) # derivate
   ddnddwlcol = np.polyval(dpolyfitdndwl, wlcol)# get
   
   scladcol = wlcol**2 * ddnddwlcol
   
   return ncladcol, Ncladcol, scladcol