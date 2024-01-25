
import numpy as np
from scipy.constants import c 

def wl_freq_omega(startfreq,stopfreq, mm):

    freqcol = np.linspace(startfreq,stopfreq, mm)
    wlcol = c / freqcol
    omegacol = 2*np.pi * freqcol
    kcol = np.zeros(mm)
    
    return freqcol, wlcol, omegacol, kcol

