//Add this to the "add some functions here... if you'd like" in EEG_Processing.pde


float getCoherence(FFT A, FFT B, int indexRangeStart, int indexRangeEnd)
  {
    float SAA = getPowerSpectrum(A, indexRangeStart, indexRangeEnd);
    float SBB = getPowerSpectrum(B, indexRangeStart, indexRangeEnd);
    Complex SAB = getCrossPowerSpectrum(A, B, indexRangeStart, indexRangeEnd);
    float SABMagnitude = getMagnitude(SAB.getReal(), SAB.getImag());
    float coherence = pow(SABMagnitude, 2) / (SAA * SBB);
    return coherence;
  }
  
  float getMagnitude(float realPart, float imaginaryPart)
  {
      float a = sqrt(pow(realPart, 2) + pow(imaginaryPart, 2));
      return a;
  }
  
  float getPowerSpectrum(FFT A, int indexRangeStart, int indexRangeEnd)
  {
    int n = indexRangeEnd - indexRangeStart + 1;
    float powerSpectrum = 0;
    for (int i = indexRangeStart; i <= indexRangeEnd; i++)
    {
      Complex normal = new Complex(A.getSpectrumReal()[i], A.getSpectrumImaginary()[i]);
      Complex conjugate = new Complex(normal.getReal(), normal.getImag() * -1);
      powerSpectrum += normal.multi(conjugate).getReal();
    }
    powerSpectrum /= pow(n,2);             //THIS COULD BE A REASON WHY YOU'RE NOT GETTING 0-1, look at the square?
    return powerSpectrum;
  }
  
  Complex getCrossPowerSpectrum(FFT A, FFT B, int indexRangeStart, int indexRangeEnd)
  {
    int n = indexRangeEnd - indexRangeStart + 1;
    Complex crossPowerSpectrum = new Complex(0,0);
    for (int i = indexRangeStart; i <= indexRangeEnd; i++)
    {
      Complex BNormal = new Complex(B.getSpectrumReal()[i], B.getSpectrumImaginary()[i]);
      Complex AConjugate = new Complex(A.getSpectrumReal()[i], A.getSpectrumImaginary()[i] * -1);
      Complex tempComplex = BNormal.multi(AConjugate);
      crossPowerSpectrum.setReal(crossPowerSpectrum.getReal() + tempComplex.getReal());
      crossPowerSpectrum.setImag(crossPowerSpectrum.getImag() + tempComplex.getImag());
    }
    crossPowerSpectrum.setReal(crossPowerSpectrum.getReal() / pow(n,2));  //THIS COULD BE A REASON WHY YOU'RE NOT GETTING 0-1, look at the square?
    crossPowerSpectrum.setImag(crossPowerSpectrum.getImag() / pow(n,2));
    return crossPowerSpectrum;
  }
  
  
  
  
  
  
  
 //And create a class Complex
  
 class Complex
{
  float real;
  float imag; 
  
  public Complex(float real, float imag)
  {
    this.real = real; 
    this.imag = imag; 
  }
  
  public Complex multi(Complex c)
  {
    float real = this.real * c.real - this.imag * c.imag;
    float imag = this.real * c.imag + this.imag * c.real;
    return new Complex(real, imag);
  }
  
  public void setReal(float n)
  {
    real = n;
  }
  
  public void setImag(float n)
  {
    imag = n;
  }
  
  public float getReal()
  {
    return real;
  }
  
  public float getImag()
  {
    return imag;
  }
}