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
		b = new String("bycjfdsbknfdsgj,gnv,vjyncghhnfjhvdbnfchdjhjdfgkfhkcnjhcbfkgxcjbgsnjdbc,fxcnjgchdfbxycnv slfgbdmfxnb ,mjkdtestbsfsluifgsnldgjj",Algorithms.SHIFT_ADD);
		
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
			contains_algs[Algorithms.BRUTE_FORCE] = ContainsAlgWrapper(){ alg = (o) => {return shift_add(o, null)>0;} };
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
		
			Gee.HashMap<int, ArrayList<bool>> masks = null;
		
			private int shift_add(String pat, out int pos){
				
				int result = 0;
				
				bool[,] table = new bool[data.length+1,pat.data.length];
				//var table = new ArrayList<ArrayList<bool>>();
				masks = masks ?? create_masks(pat);
				bool[] column = new bool[pat.data.length];

				for (int i = 0; i<pat.data.length+1; i++){
					table[0,i] = false;
				}
				
				for (int j = 1; j<=data.length; j++){

					column[0] = true;
					//TODO check pat > 1
					for (int i=1; i<pat.data.length; i++){
						column[i] = table[j-1,i-1];
						//if (table[j-1,i]) stdout.printf("1 ");
						//else stdout.printf("0 ");
					}
					//stdout.printf("\n");
					/*column = tmp_column[1:pat.data.length];
					//column[pat.data.length-1] = tmp_column[0];
					column += tmp_column[0];*/
					
															
					//print_array(column);

					//var j_mask = masks[data[j]] ?? new ArrayList<bool>();
					var j_mask = masks[data[j]];
					/*stdout.printf(@"$(data[j])\n");
					if (j_mask != null){
						stdout.printf(@"$(j_mask.size)\n");
						foreach (bool b in j_mask){
							if (b) stdout.printf("1 ");
							else stdout.printf("0 ");
						}
						stdout.printf("\n");
					}*/

					for (int i=0; i<pat.data.length; i++){
						//stdout.printf("%d %d\n",pat.data.length,(j_mask!=null)?j_mask.size:0);
						//bool mask_result = (j_mask[i]==null) ? j_mask[i] : false;
						bool temp = (j_mask!=null)? j_mask[i] : false;
						table[j,i] = column[i] && temp;
					}
					
					if (table[j,pat.data.length-1]){
						result++;
						if (result == 1){
							pos = j-pat.data.length+1;
						}
					}
				}
				
				
				return result;
				
			}
			
			public void print_table(bool[,] table){
				for (int j=0; j<=table.length[0]; j++){
					for (int i=0; i<table.length[1]; i++){
						if (table[j,i]) stdout.printf("1 ");
						else stdout.printf("0 ");
					}
					stdout.printf("\n");
				}
			}
			public void print_array(bool[] array){
				for (int i=0; i<array.length; i++){
					if (array[i]) stdout.printf("1 ");
					else stdout.printf("0 ");
				}
				stdout.printf("\n");
			}
			
			public void preprocess(String pat){
				masks = create_masks(pat);
			}
			
			private Gee.HashMap<int, ArrayList<bool>> create_masks(String pat){
				var result = new Gee.HashMap<int, ArrayList<bool>>();
				char[] encountered = {};
				//bool[] mask = new bool[pat.data.length];
				foreach (char c in pat.data){
					var mask = new ArrayList<bool>();
					if (!(c in encountered)){
						//int i = 0;
						foreach (char cpat in pat.data){
							//stdout.printf(@"$cpat $i\n");
							mask.add(c==cpat);
							//mask[i] = c==cpat;
							//i++;
						}
						/*stdout.printf("%d %d\n",i, mask.size);
						mask.clear();
						foreach (bool b in mask){
							if (b) stdout.printf("1 ");
							else stdout.printf("0 ");
						}
						stdout.printf("\n");*/
						
						//ArrayList<bool> mask_glib_array = new Array(false,false,sizeof(bool));
						result[c] = mask;
						encountered += c;
					}
				}
				return result;
			}
		
		
	}
}
