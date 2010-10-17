// project created on 06.10.2010 at 11:56
using GLib;
using Gee;

using BruteForce;
using Kmp;
using Bmh;
using ShiftAnd;

namespace Strings{
	
	public enum Algorithms {
		BRUTE_FORCE,
		KMP,
		BMH,
		SHIFT_AND;
		
		//TODO there should be a better way to get the length
		public int length(){
			return 4;
		}
	}
	
	
	int main (string[] args) {
		Test.init(ref args);
		Test.add_func("/string_algorithms",test);
		return Test.run();
	}
	
	
		
	public class String: Object {
		
		public char[] data;
		
		public delegate int[] Alg(char[] text, char[] pat);
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
			algs[Algorithms.BMH] = AlgWrapper(){ alg = bmh };
			algs[Algorithms.SHIFT_AND] = AlgWrapper(){ alg = shift_and };
			
			contains_algs[Algorithms.BRUTE_FORCE] = ContainsAlgWrapper(){ alg = bruteforce_contains };
		}
		
		public String(string b, Algorithms Algorithm = Algorithms.BRUTE_FORCE) {
			
			data = b.to_utf8();
	
			match_alg = algs[Algorithm].alg;
			contains_alg = contains_algs[Algorithm].alg;
		}
						
		private Alg match_alg;
		public int[] match(String o){
			return match_alg(data, o.data);
		}
				
		ContainsAlg contains_alg;
		public bool contains(String o){
			return contains_alg(data, o.data);
		}
	}

}