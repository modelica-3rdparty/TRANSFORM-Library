within TRANSFORM.PeriodicTable;
package Elements
annotation (Documentation(info="<html>
<p>Package which contains each of the elements explicitly called out. These are autogenerated using in an external tool (e.g., python) with code similar to that below and then the results copied and pasted.</p>
<p>Where symbols are the symbols from &quot;SimpleTable&quot;</p>
<p>with open(&apos;test.txt&apos;,&apos;w&apos;) as fil:</p>
<p>    for s in symbols:</p>
<p>        fil.write(&apos;record {}\\n&apos;.format(s))</p>
<p>        fil.write(&apos;extends TRANSFORM.PeriodicTable.Elements.PartialElement(\\n&apos;)</p>
<p>        fil.write(&apos;symbol = &quot;{}&quot;);\\n&apos;.format(s))</p>
<p>        fil.write(&apos;end {};\\n\\n&apos;.format(s))</p>
</html>"));
end Elements;
