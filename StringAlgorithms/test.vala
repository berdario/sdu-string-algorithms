using Strings;

String a = null;
String b = null;
Timer timer;
	
void test(){
	timer = new Timer();

	var contents = new FileContents();
	foreach (string content in contents){
		//TODO
	}
	
	a = new String("test");
	b = new String("bycjfdsbknfdsgj,gnv,vjyncghhnfjhvdbnfchdjhjdfgkfhkcnjhcbfkgxcjbgsnjdbc,fxcnjgchdfbxycnv slfgbdmfxnb ,mjkdtestbsfsluifgsnldgjj"
		,Algorithms.BRUTE_FORCE);
	
	
	//string file_content;
	int len = 9999;//file_content.length;
	int rint = Test.rand_int_range(len/2,len*7/8);
	//string test_string = file_content[rint:rint+len/8];
	string test_string = "the brown fox jumped over the lazy dog";
	
	
	
	int result;
	int pos;
	timer.reset();
	timer.start();
	result = b.match(a,out pos);
	timer.stop();
	stdout.printf("\nstring a is"+ ((result>0)?"":" not") +" contained "+((result>0)?@"$result time(s) ":"")+"in string b\n");
	if (result>0) stdout.printf(@"the position of the first match is at char number $pos\n");
	stdout.printf("computation performed in %f milliseconds\n",timer.elapsed()*1000);
	assert(result>0);
}

private class FileContents {
	
	static string[] plaintext_files = {
		"aaa.txt",
		"alice29.txt",
		"alphabet.txt",
		"asyoulik.txt",
		"lcet10.txt",
		"pi.txt",
		"random.txt",
		"E.coli",
		"y.tab.c"
	};
	
	static string postscript = "string.ps.gz";
		
	public FileContents iterator(){
		return this;
	}
	
	
	public string? next_value(){
		//TODO implements with the read_until_async
		string content = "";
		
		for (int i=0; i<plaintext_files.length; i++){
			if (plaintext_files[i] != null){
				var file = File.new_for_path("../../../ProjectDataSets/"+plaintext_files[i]);
				if (!file.query_exists(null)){
					stderr.printf(@"\nApparently we are in the wrong directory: $(file.get_path())\n");
				} else{
					try{
						var input = new DataInputStream(file.read());
						string line;
						while ((line = input.read_until("\n\n\n", null)) != null){
							content += line;
						}
					} catch (Error e) {
						error (e.message);
					}
				}
			 	plaintext_files[i] = null;
			 	return content;
			 }
		}
		
		if (postscript != null){
			//TODO
			postscript = null;
		}
		
		return null;
	}

}