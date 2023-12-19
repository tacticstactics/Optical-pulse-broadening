def propagate1(opl1=1, opl2=1, Ein=np.array([[1],[0]])):

    propagatematrix1 = np.array([[np.exp(1j*opl1),0],[0,np.exp(1j*opl2)]]);

    Eout = np.dot(propagatematrix1,Ein)
    
    return Eout

def propagate1(opl1=1, opl2=1, Ein=np.array([[1],[0]])):

    propagatematrix1 = np.array([[np.exp(1j*opl1),0],[0,np.exp(1j*opl2)]]);

    Eout = np.dot(propagatematrix1,Ein)
    
    return Eout
