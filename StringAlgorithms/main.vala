// project created on 06.10.2010 at 11:56
using GLib;

namespace StringAlgorithms {
	
	public enum Algorithms {
		BRUTE_FORCE,
		SHIFT_ADD;
		
		//TODO there should be a better way to get the length
		public int length(){
			return 2;
		}
	}
	
	int main (string[] args) {		
		Timer timer = new Timer();

		String a,b;
		a = new String("test");
		b = new String("bycjfdsbknfdsgj,gnv,vjyncghhnfjhvdbnfchdjhjdfgkfhkcnjhcbfkgxcjbgsnjdbc,fxcnjgchdfbxycnv slfgbdmfxnb ,mjkdtestbsfsluifgsnldgjj");
		
		test(a,b,timer);
		
		//a =new String("",algorithms.SHIFT_ADD);
		//b =new String("",algorithms.SHIFT_ADD);
		return 0;
	}
	
	void test(String a, String b, Timer timer){
		bool result;
		int pos;
		timer.reset();
		timer.start();
		result = b.match(a,out pos)>0;
		timer.stop();
		stdout.printf("string a is"+ (result?"":" not") +" contained in string b\n");
		stdout.printf("computation performed in %f milliseconds\n",timer.elapsed()*1000);
	}
		
	public class String: GLib.Object {
		
		public char[] data;
		
		public delegate int Alg(String o, out int pos);
		private delegate bool ContainsAlg(String o);
		
		private struct AlgWrapper{
			public Alg alg;
		}
		
		private struct ContainsAlgWrapper{
			public ContainsAlg alg;
		}
		
		//TODO: Algorithms.length() should work
		private static AlgWrapper[] algs = new AlgWrapper[Algorithms.BRUTE_FORCE.length()];
		private static ContainsAlgWrapper[] contains_algs = new ContainsAlgWrapper[Algorithms.BRUTE_FORCE.length()];
		
		private void setup_algs(){
			algs[Algorithms.BRUTE_FORCE] = AlgWrapper(){ alg = bruteforce };
			algs[Algorithms.SHIFT_ADD] = AlgWrapper(){ alg = shift_add };
			
			contains_algs[Algorithms.BRUTE_FORCE] = ContainsAlgWrapper(){ alg = bruteforce_contains };
		}
		
		public String(string b, Algorithms Algorithm = Algorithms.BRUTE_FORCE) {
			setup_algs();
			
			data = b.to_utf8();

			match = algs[Algorithm].alg;
			@delegate = contains_algs[Algorithm].alg;
		}
						
		ContainsAlg @delegate;
		public Alg match;
				
		public bool contains(String o){
			return @delegate(o);
		}
		
		private bool bruteforce_contains(String o){
			int i=0 ,j;
			foreach (char c in data){
				j=i;
				foreach (char c2 in o.data){
					if (data[j]!=c2){
						break;
					}
					j++;
					if (j-i>=o.data.length-1){
						return true;
					}
				}
				i++;
			}
			return false;
		
		}
		
		private int bruteforce(String o, out int pos){
			int matches = 0;
			int i=0 ,j;
			foreach (char c in data){
				j=i;
				foreach (char c2 in o.data){
					if (data[j]!=c2){
						break;
					}
					j++;
				}
				if (j-i>=o.data.length-1 && data[j]!=o.data[j-i]){
					matches++;
					if (matches == 1){
						pos = i;
					}
				}
				i++;
			}
			return matches;
		}
		
		private int shift_add(String o, out int pos){return 1;}
		
	}
}