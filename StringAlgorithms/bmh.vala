using Gee;
	
namespace Bmh{
	
	private int[] bmh(char[] text, char[] pat){
		int n = pat.length;
		int m = text.length;
		
		
		//int ALPHABET_SIZE = 0xFFFF;
		int ALPHABET_SIZE = 1024;
		int[] a = new int[ALPHABET_SIZE];
		
		//Preprocessing for bad characters
		
		for(int i = 0; i < ALPHABET_SIZE; i++){
		    a[i] = -1;
		}
		
		for(int j = n-2; j>= 0; j-- ){
		    if(a[(uint8)pat[j]] < 0){
		        a[(uint8)pat[j]] = j+1;
		    }
		}
		
		
		/*
		//int[] a = new int[pat.length/2];
		var a = new HashMap<char, int>();
		char[] encountered = {};
		char current_char;
		for(int j = n - 1; j>= 0; j-- ){
			if (!current_char in encountered){
				a[pat[j]] = m-j-1;
				stdout.printf("%i\n", j);
				encountered += pat[j];
			}
		}
		
		return a['q']??-1
		*/
	

		//Preprocessing for good suffix
		
		int[] matches = {};
		
		int k = 0;
		int shift, i, h;
		
		while (k<=m-n){
			i = n-1;
			h = k+n-1;
			while (i >= 0 && pat[i] == text[h]){
				i--;
				h--;
			}
			
			if (i < 0){
				matches += k;
			} 
			
			shift = a[(uint8)text[k+n-1]];
			//message(@"k: $k letter: $(text[k]) eowletter: $(text[k+n-1]) shift: $((shift != -1) ? n-shift : n)");
			
			k += (shift != -1) ? n-shift : n;
		}
		return matches;
	}
}
