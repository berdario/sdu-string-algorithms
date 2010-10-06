// project created on 06.10.2010 at 11:56
using GLib;
namespace StringAlgorithms {
	
	enum Algorithms {
		BRUTE_FORCE,
		SHIFT_ADD
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
		stdout.printf("computation performed in %f milliseconds\n",timer.elapsed(out micro)*1000);
	}
		
	public class String: GLib.Object {
		public char[] data;
		public String(string b) {
			data = b.to_utf8();
		}
		
		public bool contains(String o){
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