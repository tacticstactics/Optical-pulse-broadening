
import numpy as np

def sellmeiercore(wlcol = np.ones(64)):

    ncorecol = np.ones(64)
    Ncorecol = np.ones(64)
    scorecol = np.ones(64)
  
    return ncorecol, Ncorecol, scorecol

def sellmeierclad(wlcol = np.ones(64)):

    ncladcol = np.ones(64)
    Ncladcol = np.ones(64)
    scladcol = np.ones(64)

    return ncladcol, Ncladcol, scladcol
