// project created on 06.10.2010 at 11:56
using GLib;
using Gee;
using BruteForce;
using Kmp;
using Bm;
using ShiftAnd;

	
public enum Algorithms {
	BRUTE_FORCE,
	KMP,
	BM,
	SHIFT_AND;
	
	//TODO there should be a better way to get the length
	public int length(){
		return 4;
	}
}

int main (string[] args) {		
	Timer timer = new Timer();

	String a,b;
	a = new String("test");
	b = new String("bycjfdsbknfdsgj,gnv,vjyncghhnfjhvdbnfchdjhjdfgkfhkcnjhcbfkgxcjbgsnjdbc,fxcnjgchdfbxycnv slfgbdmfxnb ,mjkdtestbsfsluifgsnldgjj"
		,Algorithms.SHIFT_AND);
	test(a,b,timer);
	
	return 0;
}

void test(String a, String b, Timer timer){
	int result;
	int pos;
	timer.reset();
	timer.start();
	result = b.match(a,out pos);
	timer.stop();
	stdout.printf("string a is"+ ((result>0)?"":" not") +" contained "+((result>0)?@"$result time(s) ":"")+"in string b\n");
	if (result>0) stdout.printf(@"the position of the first match is at char number $pos\n");
	stdout.printf("computation performed in %f milliseconds\n",timer.elapsed()*1000);
}
	
public class String: Object {
	
	public char[] data;
	
	public delegate int Alg(char[] text, char[] pat, out int pos);
	private delegate bool ContainsAlg(char[] text, char[] pat);
	
	private struct AlgWrapper{
		public Alg alg;
	}
	
	private struct ContainsAlgWrapper{
		public ContainsAlg alg;
	}
	
	//TODO: Algorithms.length() should work
	private static AlgWrapper[] algs = new AlgWrapper[Algorithms.BRUTE_FORCE.length()];
	private static ContainsAlgWrapper[] contains_algs = new ContainsAlgWrapper[Algorithms.BRUTE_FORCE.length()];
	
	static construct{
		algs[Algorithms.BRUTE_FORCE] = AlgWrapper(){ alg = bruteforce };
		algs[Algorithms.KMP] = AlgWrapper(){ alg = kmp };
		algs[Algorithms.BM] = AlgWrapper(){ alg = bm };
		algs[Algorithms.SHIFT_AND] = AlgWrapper(){ alg = shift_and };
		
		contains_algs[Algorithms.BRUTE_FORCE] = ContainsAlgWrapper(){ alg = bruteforce_contains };
		//contains_algs[Algorithms.SHIFT_AND] = ContainsAlgWrapper(){ alg = (o) => {return ShiftAnd.shift_and(data, o.data, null)>0;} };
	}
	
	public String(string b, Algorithms Algorithm = Algorithms.BRUTE_FORCE) {
		
		data = b.to_utf8();

		match_alg = algs[Algorithm].alg;
		contains_alg = contains_algs[Algorithm].alg;
	}
					
	private Alg match_alg;
	public int match(String o, out int pos){
		return match_alg(data, o.data, out pos);
	}
			
	ContainsAlg contains_alg;
	public bool contains(String o){
		return contains_alg(data, o.data);
	}
}
