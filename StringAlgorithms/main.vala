// project created on 06.10.2010 at 11:56
using GLib;

namespace StringAlgorithms {
	
	public enum Algorithms {
		BRUTE_FORCE = 0,
		SHIFT_ADD;
		
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
		timer.reset();
		timer.start();
		result = a in b;
		timer.stop();
		stdout.printf("string a is"+ (result?"":" not") +" contained in string b\n");
		stdout.printf("computation performed in %f milliseconds\n",timer.elapsed()*1000);
	}
		
	public class String: GLib.Object {
		
		public char[] data;
		
		public delegate bool Alg(String o);
		
		//public Alg[] algs = new Alg[Algorithms.length()];
		//private Alg[] algs = new Alg[2];
		
		//algs[0] = (o) => {return true;};
		
		public String(string b, Algorithms Algorithm = Algorithms.BRUTE_FORCE) {
			data = b.to_utf8();
			@delegate = moot;
		}
		
		
		public Alg @delegate;
		
		private bool moot(String o){return true;}
		
		public bool contains(String o){
			return @delegate(o);
		}
		
		public bool bruteforce(String o){//(a) => 
		{
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
		}
	}
}