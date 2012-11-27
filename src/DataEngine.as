package  
{
    import mx.collections.ArrayCollection;
	/**
     * ...
     * @author Ryan Andonian
     */
    public final class DataEngine 
    {
        private static var _constructionOkay:Boolean;
        private static var _instance:DataEngine;
        
        [Bindable]
        public var dp_players:ArrayCollection;
        [Bindable]
        public var dp_targets:ArrayCollection;
        [Bindable]
        public var dp_guesses:ArrayCollection;
        
        public var main:Main;
        
        public function DataEngine()
        {
            if(!_constructionOkay)
            {
                throw new Error("You cannot instantiate the clsss " + 
                        "DataEngine. Use .instance instead")
            }
            init();
        }
        
        public function addPlayer(text:String):void 
        {
            dp_players.addItem({label: text});
        }
        
        public function log(string:String):void 
        {
            main.log(string);
        }
        
        public static function get instance():DataEngine
        {
            if(_instance == null)
            {
                _constructionOkay = true;
                _instance = new DataEngine;
                _constructionOkay = false;
            }
            return _instance;
        }
        
        private function init():void
        {
            // TODO: Initialization logic
            dp_players = new ArrayCollection();
            dp_targets = new ArrayCollection();
            dp_guesses = new ArrayCollection();
        }
        
    }

}