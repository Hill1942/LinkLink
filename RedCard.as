package  {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	
	public class RedCard extends MovieClip {
		
		public var id:uint;
		public var x_index:uint;
		public var y_index:uint;
		public var state:uint
		
		public var border:CardBorder;
		
		public function RedCard() {
			border = new CardBorder();
			this.state = 1;  // 1 for visible
			border.visible = false;
			addChild(border);
			//this.currentFrame
			// constructor code
		}
		
		public function DrawFrame() {

		}
	}
	
}
