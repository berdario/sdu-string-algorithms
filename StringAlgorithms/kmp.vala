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
				if (matches == 1 ){
					pos = i-j;
				}
				j = N[j];
			}
		}
	
		return matches;
	}
}