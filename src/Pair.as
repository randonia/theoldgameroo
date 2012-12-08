package  
{
	/**
     * ...
     * @author Ryan Andonian
     */
    public class Pair 
    {
        private var _left:String;
        private var _right:String;
        public function get left():String { return _left; }
        public function get right():String { return _right; }
        
        public function Pair(left:String, right:String) 
        {
            _left = left;
            _right = right;
        }
        
        
    }

}