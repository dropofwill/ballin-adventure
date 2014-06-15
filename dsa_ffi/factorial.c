extern "C" unsigned long factorial(int n);

unsigned long factorial(int n){
	unsigned long f = 1;
	for (int c = 1; c <= n; c++) f *= c;
	return f;
}
