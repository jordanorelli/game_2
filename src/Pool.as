// A pool is a collection of objects of a particular type used in lieu of manual
// memory management.  By recycling our objects, we are able to prevent the garbage
// collector from picking them up.  At some point in the future, it may be worthwhile
// to regulate pools by setting an item half-life that could free pooled items on a
// timed basis, but at this point I'm hesitant to add timing elements to the Pool class.
package
{
	public final class Pool
	{
		private var newItem:Function;
		private var elements:Array = new Array();
		
		public function Pool(aConstructor:Function)
		{
			newItem = aConstructor;
		}
		
		public function get item():GameObject
		{
			for (var i:uint = 0; i < elements.length; i++)
			{
				if (elements[i].inPool)
				{
					elements[i].inPool = false;
					return elements[i];
				}
			}
			
			var aNewItem:GameObject = newItem();
			elements.push(aNewItem);
			aNewItem.inPool = false;
			return aNewItem;				
		}		
	}
}