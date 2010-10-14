using Strings;

String a = null;
String b = null;
Timer timer;

	
void test(){
	timer = new Timer();
	
	a = new String("test");
	b = new String("bycjfdsbknfdsgj,gnv,vjyncghhnfjhvdbnfchdjhjdfgkfhkcnjhcbfkgxcjbgsnjdbc,fxcnjgchdfbxycnv slfgbdmfxnb ,mjkdtestbsfsluifgsnldgjj"
		,Algorithms.BRUTE_FORCE);
	
	
	//string file_content;
	int len = 9999;//file_content.length;
	int rint = Test.rand_int_range(len/2,len*7/8);
	//string test_string = file_content[rint:rint+len/8];
	string test_string = "the brown fox jumped over the lazy dog";
	
	
	
	int result;
	int pos;
	timer.reset();
	timer.start();
	result = b.match(a,out pos);
	timer.stop();
	stdout.printf("\nstring a is"+ ((result>0)?"":" not") +" contained "+((result>0)?@"$result time(s) ":"")+"in string b\n");
	if (result>0) stdout.printf(@"the position of the first match is at char number $pos\n");
	stdout.printf("computation performed in %f milliseconds\n",timer.elapsed()*1000);
	assert(result>0);
}
