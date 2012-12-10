package  
{
	/**
     * ...
     * @author Ryan Andonian
     */
    public class Triple 
    {
        private var _player:String;
        private var _target:String;
        private var _guess:String
        
        public function Triple(plr:String, tar:String, guess:String) 
        {
            _player = plr;
            _target = tar;
            _guess = guess
        }
        
        public function toString():String
        {
            return "<b>" + _player + "</b>: " + _target + " - " + _guess;
        }
        
        public function get player():String { return _player; }
        
        public function get target():String { return _target; }
        
        public function get guess():String { return _guess; }
        
    }

}