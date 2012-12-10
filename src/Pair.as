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
        
        private var _alive:Boolean;
        public function get alive():Boolean { return _alive; }
        public function set alive(value:Boolean):void { _alive = value; }
        
        public function Pair(left:String, right:String) 
        {
            _left = left;
            _right = right;
            _alive = true;
        }
        
        public function toString():String 
        {
            return _left + ":" + right + "|" + _alive;
        }
        
        
    }

}