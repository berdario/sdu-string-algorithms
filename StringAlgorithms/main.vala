// project created on 06.10.2010 at 11:56
using GLib;
using Gee;

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
		
		//TODO: fix warning
		private static delegate bool Alg(String o);
		private delegate bool Algnotstatic(String o);
		
		public delegate int Matchingalg(String o, out int pos);
		
		private static Alg[] algs;
				
		private static void setup(){
			//TODO: Algorithms.length() should work
			algs= new Alg[Algorithms.BRUTE_FORCE.length()];
			algs[Algorithms.BRUTE_FORCE] = (Alg) bruteforce;
			algs[Algorithms.SHIFT_ADD] = (Alg) shift_add;
		}
		
		public String(string b, Algorithms Algorithm = Algorithms.BRUTE_FORCE) {
			if (algs == null){
				setup();
			}
			data = b.to_utf8();

			//@delegate = algs[Algorithm];
			@delegate = bruteforce_contains;
			match = bruteforce;
		}
						
		Algnotstatic @delegate;
		public Matchingalg match;
				
		//TODO: maybe we could make contains an Alg delegate directly, without proxying through "@delegate"
		public bool contains(String o){
			
			/*stdout.printf("\n%p\n",&data[0]);
			stdout.printf("%p\n",&o.data[0]);
			String newo = new String((string) o.data);*/
			//usestring(newo);
			
			//return @delegate(newo);
			return @delegate(o);
		}
		
		public void usestring(String o){
			stdout.printf((string) o.data);
		}
		
		private bool bruteforce_contains(String o){
			/*stdout.printf("inside bruteforce\n");
			stdout.printf("\n%p\n",&data[0]);
			stdout.printf("data: "+(string) data+"\nother: "+(string) o.data+"\n");*/
			
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