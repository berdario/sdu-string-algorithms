// project created on 06.10.2010 at 11:56
using GLib;
namespace StringAlgorithms {
	enum Algorithms {
		BRUTE_FORCE,
		SHIFT_ADD
	}
	
	int main (string[] args) {
		String a,b;
		a=new String("test");
		b=new String("btestb");
		stdout.printf("string a is"+ (a in b?"":" not") +" contained in string b");
		
		String a,b
		{
			starttimer();
			a in b;
			endtimer();
		}
		
		Stringwshiftadd c,d;
		{
			starttimer();
			a in b;
			endtimer();
		}
		
		a,b= new String("")
		
		a,b=new String("",algorithms.SHIFT_ADD)
		
		return 0;
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