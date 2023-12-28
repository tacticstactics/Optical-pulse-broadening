
import numpy as np
from scipy.constants import c 

def sellmeiercore(wlcol):

    ncorecol = wlcol
    Ncorecol = wlcol
    scorecol = wlcol
  
    return ncorecol, Ncorecol, scorecol

def sellmeierclad(wlcol):
   
   ncladcol =  np.sqrt(1 + 0.696 * wlcol**2/(wlcol)**2 - 0.004368) + 0.408 * wlcol**2/(wlcol**2 - 0.01395) + 0.896 * wlcol**2/(wlcol**2 - 97.93)
   Ncladcol = wlcol
   scladcol = wlcol
   
   return ncladcol, Ncladcol, scladcol