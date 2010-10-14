using Gee;

namespace ShiftAnd{
	HashMap<int, ArrayList<bool>> masks = null;
		
			private int shift_and(char[] text, char[] pat, out int pos){
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
			
			private HashMap<int, ArrayList<bool>> create_masks(char[] pat){
				var result = new HashMap<int, ArrayList<bool>>();
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

