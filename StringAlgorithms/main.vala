// project created on 06.10.2010 at 11:56
using GLib;
using Gee;


	
public enum Algorithms {
	BRUTE_FORCE,
	SHIFT_AND;
	
	//TODO there should be a better way to get the length
	public int length(){
		return 2;
	}
}

int main (string[] args) {		
	Timer timer = new Timer();

	String a,b;
	a = new String("test");
	b = new String("bycjfdtestsbknfdsgj,gnv,vjyncghhnfjhvdbnfchdjhjdfgkfhkcnjhcbfkgxcjbgsnjdbc,fxcnjgchdfbxycnv slfgbdmfxnb ,mjkdtestbsfsluifgsnldgjj",Algorithms.SHIFT_AND);
	test(a,b,timer);
	
	//a =new String("",algorithms.SHIFT_ADD);
	//b =new String("",algorithms.SHIFT_ADD);
	return 0;
}

void test(String a, String b, Timer timer){
	int result;
	int pos;
	timer.reset();
	timer.start();
	result = b.match(a,out pos);
	timer.stop();
	stdout.printf("string a is"+ ((result>0)?(" contained "+result.to_string()+" times"):" not") +" contained in string b\n");
	stdout.printf("computation performed in %f milliseconds\n",timer.elapsed()*1000);
}
	
public class String: GLib.Object {
	
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
		algs[Algorithms.BRUTE_FORCE] = AlgWrapper(){ alg = BruteForce.bruteforce };
		algs[Algorithms.SHIFT_AND] = AlgWrapper(){ alg = ShiftAnd.shift_and };
		
		contains_algs[Algorithms.BRUTE_FORCE] = ContainsAlgWrapper(){ alg = BruteForce.bruteforce_contains };
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

namespace BruteForce{
	private bool bruteforce_contains(char[] text, char[] pat){
			int i=0 ,j;
			foreach (char c in text){
				j=i;
				foreach (char c2 in pat){
					if (text[j]!=c2){
						break;
					}
					j++;
					if (j-i>=pat.length-1){
						return true;
					}
				}
				i++;
			}
			return false;
		
		}
		
		private int bruteforce(char[] text, char[] pat, out int pos){
			stdout.printf("bruteforce!\n");
			int matches = 0;
			int i=0 ,j;
			foreach (char c in text){
				j=i;
				foreach (char c2 in pat){
					if (text[j]!=c2){
						break;
					}
					j++;
				}
				if (j-i>=pat.length-1 && text[j]!=pat[j-i]){
					matches++;
					if (matches == 1){
						pos = i;
					}
				}
				i++;
			}
			return matches;
		}
}

namespace ShiftAnd{
	Gee.HashMap<int, ArrayList<bool>> masks = null;
		
			private int shift_and(char[] text, char[] pat, out int pos){
				stdout.printf("shiftand!\n");
				int result = 0;
				int m = text.length;
				int n = pat.length;
				bool[,] table = new bool[m+1,n];
				//var table = new ArrayList<ArrayList<bool>>();
				masks = masks ?? create_masks(pat);
				bool[] column = new bool[n];

				for (int i = 0; i<n+1; i++){
					table[0,i] = false;
				}
				
				for (int j = 1; j<=m; j++){

					column[0] = true;
					//TODO check pat > 1
					for (int i=1; i<n; i++){
						column[i] = table[j-1,i-1];
						//if (table[j-1,i]) stdout.printf("1 ");
						//else stdout.printf("0 ");
					}
					//stdout.printf("\n");
					/*column = tmp_column[1:n];
					//column[n-1] = tmp_column[0];
					column += tmp_column[0];*/
					

															
					//print_array(column);

					//var j_mask = masks[text[j]] ?? new ArrayList<bool>();
					var j_mask = masks[text[j]];
					/*stdout.printf(@"$(text[j])\n");
					if (j_mask != null){
						stdout.printf(@"$(j_mask.size)\n");
						foreach (bool b in j_mask){
							if (b) stdout.printf("1 ");
							else stdout.printf("0 ");
						}
						stdout.printf("\n");
					}*/

					for (int i=0; i<n; i++){
						//stdout.printf("%d %d\n",n,(j_mask!=null)?j_mask.size:0);
						//bool mask_result = (j_mask[i]==null) ? j_mask[i] : false;
						bool temp = (j_mask!=null)? j_mask[i] : false;
						table[j,i] = column[i] && temp;
					}
					
					if (table[j,n-1]){
						result++;
						if (result == 1){
							pos = j-n+1;
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
			
			public void preprocess(char[] pat){
				masks = create_masks(pat);
			}
			
			private Gee.HashMap<int, ArrayList<bool>> create_masks(char[] pat){
				var result = new Gee.HashMap<int, ArrayList<bool>>();
				char[] encountered = {};
				//bool[] mask = new bool[n];
				foreach (char c in pat){
					var mask = new ArrayList<bool>();
					if (!(c in encountered)){
						//int i = 0;
						foreach (char cpat in pat){
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

namespace Kmp{
	private int kmp(char[] text, char[] pat, out int pos){

             int n = pat.length;
             int i = 0;
             int j = -1;
             int[] N = new int[n+1];
             N[i] = j;

             //building the table
             while(i < n){
                 while(j >= 0 && (pat[j] != pat[i])){
                     j = N[j];
                 }
                 i++;
                 j++;
                 N[i] = j;

             }

             foreach (int c in N){
                 stdout.printf("%i\n", c);
             }

             //searching
             i = 0;
             j = 0;
             int matches = 0;
             while(i < text.length){
                 while(j >= 0 && (text[i] != pat[j])){
                     j = N[j];
                 }
                 i++;
                 j++;

                 if(j == n){
                     matches++;
                     j = N[j];
                 }
             }

             stdout.printf("%i\n", matches);
             return matches;
         }
}

namespace Bm{
	private int bm(char[] text, char[] pat, out int pos){
             int ALPHABET_SIZE = 1024;
             int[] a = new int[ALPHABET_SIZE];

             //Preprocessing for bad characters
             for(int i = 0; i < ALPHABET_SIZE; i++){
                 a[i] = -1;
             }

             for(int j = pat.length - 1; j>= 0; j-- ){
                 if(a[pat[j]] < 0){
                     a[pat[j]] = j;
                     stdout.printf("%i\n", j);
                 }
             }

             //Preprocessing for good suffix

             return -1;
         }
}