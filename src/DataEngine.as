package  
{
    import adobe.utils.CustomActions;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import mx.collections.ArrayCollection;
	/**
     * ...
     * @author Ryan Andonian
     */
    public final class DataEngine 
    {
        private static var _constructionOkay:Boolean;
        private static var _instance:DataEngine;
        
        private static const SAVEFILE:String = "gamedata.derp";
        
        public var playerData:Vector.<Pair>;
        
        
        [Bindable]
        public var dp_players:ArrayCollection;
        [Bindable]
        public var dp_targets:ArrayCollection;
        [Bindable]
        public var dp_guesses:ArrayCollection;
        
        [Bindable]
        public var dp_answers:ArrayCollection;
        
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
        
        public function addPlayer(text:String, export:Boolean = true):void 
        {
            var splitter:RegExp = /\s*[-=]\s*/g;
            var entry:Array = text.split(splitter);
            playerData.push(new Pair(entry[0], entry[1]));
            updateDataProviders();
            if(export)
                exportToXML();
        }
        
        private function updateDataProviders():void
        {
            // Update the players data provider and the answers data provider
            dp_players.removeAll();
            dp_answers.removeAll();
            for each (var p:Pair in playerData)
            {
                dp_players.addItem( { label: p.left, answer: p.right } );
                dp_answers.addItem( { label: p.right } );
            }
        }
        
        public function log(string:String):void 
        {
            if(main)
                main.log(string);
            else
                trace(string);
        }
        
        /**
         * Returns the index of the player in the players vector. -1 if they aren't there
         * @param	array
         * @return
         */
        public function getPlayerIndex(key:String):int 
        {
            var result:int = -1
            for each(var p:Pair in playerData)
            {
                if (p.left == key) 
                {
                    result = playerData.indexOf(p);
                    break;
                }
            }
            return result;
        }
        
        /**
         * Functions similarly to getPlayerIndex, except for guesses
         * @param	array
         */
        public function getGuessIndex(guess:String):int
        {
            var result:int = -1;
            for each(var p:Pair in playerData)
            {
                if (p.right == guess)
                {
                    result = playerData.indexOf(p);
                    break;
                }
            }
            return result;
        }
        
        public function getPlayerByIndex(selectedIndex:int):String 
        {
            var result:String = "";
            if (selectedIndex < playerData.length)
            {
                result = playerData[selectedIndex].left;
            }
            return result;
        }
        
        public function getGuessByIndex(selectedIndex:int):String
        {
            var result:String = "";
            if (selectedIndex < playerData.length)
            {
                result = playerData[selectedIndex].right;
            }
            return result;
        }
        
        
        /**
         * This assumes proper data input. Bad assumption, but hopefully that'd be fixed in the 
         * submission viewing
         * @param	results
         */
        public function processResults(results:Vector.<Triple>):void 
        {
            log("Processing results!");
            var email:String = "";
            
            var guesses:Vector.<String> = new Vector.<String>();
            var answers:Vector.<String> = new Vector.<String>();
            
            for each(var submission:Triple in results)
            {
                var plr:String = submission.player;
                var trg:String = submission.target;
                var gus:String = submission.guess;
                
                // Grab the target for comparison
                var targetPair:Pair = playerData[getPlayerIndex(trg)];
                // Check if the target was hit
                if (targetPair.left == trg && targetPair.right == gus)
                {
                    trace("Player hit! " + targetPair.toString());
                    answers.push(submission.toString());
                }
                else
                {
                    guesses.push(trg + " - " + gus);
                }
            }
            
            // Append the answers
            email += "THE ANSWERS" + "\n";
            for each(var answer:String in answers)
            {
                email += answer + "\n";
            }
            if (answers.length == 0)
            {
                email += "No correct guesses\n";
            }
            
            // Append the guesses
            email += "THE GUESSES" + "\n";
            for each(var guess:String in guesses)
            {
                email += guess + "\n";
            }
            
            trace(email);
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
            playerData = new Vector.<Pair>();
            
            // TODO: Initialization logic
            dp_players = new ArrayCollection();
            dp_targets = new ArrayCollection();
            dp_guesses = new ArrayCollection();
            dp_answers = new ArrayCollection();
            
            parseFromXML();
            
            //playerData.push(new Pair("Charlotte", "Foo"));
            //playerData.push(new Pair("David", "Bar"));
            //playerData.push(new Pair("Chris", "Baz"));
            updateDataProviders();
        }
        
        private function parseFromXML():void 
        {
            log("Parsing from XML");
            
            var fs:FileStream = getFileStream(SAVEFILE, false);
            var dataXML:XML = XML(fs.readUTFBytes(fs.bytesAvailable));
            fs.close();
            
            // Parse the players
            for each(var player:XML in dataXML.players.player)
            {
                addPlayer(player.name[0] + " - " + player.answer[0], false);
            }
            
        }
        
                /**
         * Saves the state to XML!
         */
        private function exportToXML():void 
        {
            log("Exporting to XML");
            var result:XML = XML(<gameroo/>);
            
            var players:XML = XML(<players/>);
            for each(var player:Pair in playerData)
            {
                players.appendChild(player.toXML());
            }
            result.appendChild(players);
            
            var fs:FileStream = getFileStream(SAVEFILE, true);
            
            fs.writeUTFBytes(result.toXMLString());
        }
        
        
        private function getFileStream(fileName:String, write:Boolean):FileStream
        {
            var fs:FileStream;
            
            var mode:String = (write)?FileMode.WRITE:FileMode.READ;
            
            var file:File = File.applicationStorageDirectory.resolvePath(fileName);
            
            if (!file.exists)
            {
                log("File doesn't exist, creating a new one");
                var wr:File = new File(file.nativePath);
                var stream:FileStream = new FileStream();
                stream.open(wr, FileMode.WRITE);
                stream.writeUTFBytes("");
                stream.close();
            }
            
            fs = new FileStream();
            fs.open(file, mode);
            
            return fs;
        }
    }
}