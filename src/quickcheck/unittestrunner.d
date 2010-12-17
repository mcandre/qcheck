module quickcheck.unittestrunner;

private {
  import core.runtime;
  import std.stdio : writeln;
  import std.array : rjustify;
  import std.algorithm : min, max;
}

version(unittest):

static this () {
  core.runtime.Runtime.moduleUnitTester(&unittestrunner);
}

bool unittestrunner()
{
  writeln("\nRUNNING UNITTESTS\n");
  size_t failCnt = 0;
  foreach(ref m; ModuleInfo )
  {
    if( m )
    {
      auto fp = m.unitTest;
      if( fp )
      {
	auto msg = "TEST: "~m.name;
	try
	{
	  fp();
	  msg ~= " OK".rjustify(max(0, 79 - msg.length));
	}
	catch( Throwable e )
	{
	  msg ~= " FAILED".rjustify(max(0, 79 - msg.length))
	    ~ "\n" ~ e.toString ~ "\n";
	  ++failCnt;
	}
	writeln(msg);
      }
    }
  }
  if (failCnt != 0) {
    throw new Exception("Unittest failed.");
  } else {
    return true;
  }
}