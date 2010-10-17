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
		
		private int[] bruteforce(char[] text, char[] pat){
			int[] matches = {};
			int i=0 ,j;
			foreach (char c in text){
				j=i;
				foreach (char c2 in pat){
					if (text[j]!=c2){
						break;
					}
					j++;
				}
				if (j-i==pat.length ){//&& text[j]!=pat[j-i]){
					matches+=i;
				}
				i++;
			}
			return matches;
		}
}
