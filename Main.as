package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.display.StageQuality;
	import BasicObstacle;
	import flash.text.StaticText;
	
	public class Main extends MovieClip {
		
		var backgroundMapDirection = null;
		var speed:int = 0;
		var beasts:Array = new Array();
		var characterInstance:Character;
		var gamePaused:Boolean = false;
		var battleBegun:Boolean = false;
		var battle:BattleStage;
		var framesReady:Dictionary = new Dictionary();
		var rat:Rat;
		var gameOver:Boolean = false;
		var characterHealth: Number = 100;
		var characterAttack: Number = 10;
		var characterSpeed: Number = 5;
		var characterDefend: Number = 1;
		var characterExperience: Number = 0;
		var characterStats = new Dictionary();
		var gameWon:Boolean = false;
		
		var obstaclesArray:Array = new Array();
		var sortingArray:Array = new Array();
		
		var started:Boolean = false;
		
		var caveArea:Boolean = false;
		
		var statUpScreen:StatUpScreen;

		public function Main() {

			// SET THE STAGE QUALITY TO LOW
			stage.quality = StageQuality.LOW;
				
			// constructor code
			stage.addEventListener(Event.ENTER_FRAME, centralUpdate);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyDownHandler);
			
			// POPULATE AND ARRAY OF ALL THE OBSTACLES ON THE CURRENT MAP
			populateObstaclesArray();
			
			characterStats["characterHealth"] = characterHealth;
			characterStats["characterAttack"] = characterAttack;
			characterStats["characterSpeed"] = characterSpeed;
			characterStats["characterDefend"] = characterDefend;
			characterStats["characterExperience"] = characterExperience;
		
			// SPAWN A NEW CHARACTER
			characterInstance = new Character(beasts, this);
			characterInstance.x = 576;
			characterInstance.y = 622;
			characterInstance.setObstaclesArray(obstaclesArray);
			characterInstance.scaleX = 1.3;
			characterInstance.scaleY = 1.3;
			this.addChild(characterInstance);
			
			// DEFINE WHAT SCENE TO SPAWN WHEN
			framesReady["Beach"] = false;
			framesReady["Battle Scene"] = false;
			framesReady["Forest"] = true;
			framesReady["Boss"] = true;
		}
		
		// CENTRAL UPDTAE FUNCTION CONTROLLING ALL UPDATES
		private function centralUpdate(e:Event):void {

			// CHECK IF YOU HIT AN ENEMY
			battleCheck();
			
			// SPAWNS NEW WORLDS IN WHEN YOU NEED THEM
			frameManager();
			
			// GET THE CHARATER'S SPEED
			this.speed = characterInstance.getSpeed();
			
			// IF THE GAME ISN'T PAUSED
			if (gamePaused == false) {
				
				// SORT ALL OBJECTS ON THE SCREEN SO THAT IT LOOKS RIGHT WHEN YOU WALK BEHIND TREES
				stackingOrderSorting();
				
				// UPDATE THE CHARACTER
				characterInstance.update();
				this.backgroundMapDirection = characterInstance.getMapDirection();
				backgroundMapUpdate();
				
				// UPDATE ALL THE ENEMIES
				for (var i = 0; i < beasts.length; i++) {
					
					if (beasts[i] != null) {
						
						beasts[i].update();
					}
				}
				
				// IF YOU HIT AN ENEMY
				if (characterInstance.getCaveEntered()) { 
					
					// REMOVE ALL THE ENEMIES
					for (i = 0; i < beasts.length; i++) {
						
						if (beasts[i] != null) {
							
							this.removeChild(beasts[i]);							
						}
						
						beasts[i] = null;
						//beasts.splice(i, 1);
					}
					
					// REMOVE ALL THE OBSTACLES
					for (i = 0; i < obstaclesArray.length; i++) {
						
						if (obstaclesArray[i] != null) {
						
							this.removeChild(obstaclesArray[i]);
						}
						
						obstaclesArray[i] = null;
					}
					
					if (this.currentFrame == 1) {
					
						framesReady["Forest"] = false;
					}
					
					if (this.currentFrame == 2) {
						
						framesReady["Boss"] = false;
					}
					
					obstaclesArray = null;
					obstaclesArray = new Array();
					sortingArray = null;
					sortingArray = new Array();
					nextFrame();
				}
				
				// IF YOU LOSE OR WIN THE GAME, GO TO THE END SCREENS
				if (gameOver == true || gameWon == true) {
					
					for (i = 0; i < beasts.length; i++) {
						
						if (beasts[i] != null) {
							
							this.removeChild(beasts[i]);							
						}
						
						beasts[i] = null;
						//beasts.splice(i, 1);
					}
					
					for (i = 0; i < obstaclesArray.length; i++) {
						
						if (obstaclesArray[i] != null) {
						
							this.removeChild(obstaclesArray[i]);
						}
						
						obstaclesArray[i] = null;
					}
					
					if (gameOver == true) {
						this.gotoAndStop(4);
					}
					
					if (gameWon == true) {
						
						this.gotoAndStop(5);
					}
					gamePaused = true;
					
					return;
				}
			}
		}
		
		// SPAWNS ENEMIES IN WHEN THEY NEED TO BE SPAWNED IN
		private function frameManager():void {

			if (framesReady["Beach"] == false) {
				
				trace("BEACH");
				
				framesReady["Beach"] = true;
				
				for (var i = 0; i < 10; i++) {
					
					var rat = new Rat(obstaclesArray, this);
					rat.x = Math.random() * 2000;
					rat.y = Math.random() * 1500;
					beasts.push(rat);
					this.addChild(rat);
					this.setChildIndex(rat, this.numChildren - 3);
				}
				
				for (i = 0; i < 10; i++) {
					
					var ogre:Ogre = new Ogre(obstaclesArray, this);
					ogre.x = Math.random() * 2000;
					ogre.y = Math.random() * 1500;
					beasts.push(ogre);
					this.addChild(ogre);
					this.setChildIndex(ogre, this.numChildren - 2);
				}
				
				for (i = 0; i < 10; i++) {
					
					var skeleton:Skeleton = new Skeleton(obstaclesArray, this);
					skeleton.x = Math.random() * 2000;
					skeleton.y = Math.random() * 1500;
					beasts.push(skeleton);
					this.addChild(skeleton);
					this.setChildIndex(skeleton, this.numChildren - 2);
				}
				
				populateSortingArray();
			}
			
			if (framesReady["Battle Scene"] == false && battleBegun == true) {
				
				framesReady["Battle Scene"] = true;
				
				gamePaused = true;
				battleBegun = false;
				battle = new BattleStage(characterInstance.getEnemyType(), this, characterStats, caveArea);
				battle.x = 0;
				battle.y = 0;
				this.addChild(battle);
			}
			
			if (framesReady["Forest"] == false) {
				
				
				trace("FOREST");
				characterInstance.setCaveEntered(false);
				
				framesReady["Forest"] = true;
				
				characterInstance.setObstaclesArray(obstaclesArray);
				
				beasts = new Array();
				
				
				
				for (i = 0; i < 5; i++) {
					
					ogre = new Ogre(obstaclesArray, this);
					ogre.x = -200 + Math.random() * 2200;
					ogre.y = -1000 + Math.random() * 1300;
					beasts.push(ogre);
					this.addChild(ogre);
					this.setChildIndex(ogre, this.numChildren - 2);
					
					//trace("OLAF");
				}
				
				for (i = 0; i < 5; i++) {
					
					skeleton = new Skeleton(obstaclesArray, this);
					skeleton.x = -200 + Math.random() * 2200;
					skeleton.y = -1000 + Math.random() * 1300;
					beasts.push(skeleton);
					this.addChild(skeleton);
					this.setChildIndex(skeleton, this.numChildren - 2);
					
					//trace("OLAF");
				}
				
				for (i = 0; i < 5; i++) {
					
					rat = new Rat(obstaclesArray, this);
					rat.x = -200 + Math.random() * 2200;
					rat.y = -1000 + Math.random() * 1300;
					beasts.push(rat);
					this.addChild(rat);
					this.setChildIndex(rat, this.numChildren - 3);
				}

				populateSortingArray();
				populateObstaclesArray();
				characterInstance.setEnemyArray(beasts);
			}
			
			if (framesReady["Boss"] == false) {
				
				trace("BOSS");
				
				caveArea = true;
				
				framesReady["Boss"] = true;
				
				populateSortingArray();
				populateObstaclesArray();
				trace(obstaclesArray.length);
				characterInstance.setEnemyArray(beasts);
				characterInstance.setCaveEntered(false);
				characterInstance.setObstaclesArray(obstaclesArray);
				
				var deathLord = new DeathLord();
				deathLord.x = 500;
				deathLord.y = 200;
				beasts.push(deathLord);
				this.addChild(deathLord);
				this.setChildIndex(deathLord, this.numChildren - 2);
				
				
				trace(stage.numChildren + "numChildren");
				//this.setChildIndex(backgroundMap, 1);
				this.setChildIndex(characterInstance, 1);
			}
			
			// IF YOUR IN BATTLE, UPDATE THE BATTLE
			if (framesReady["Battle Scene"] == true && battle.parent != null) {
				
				battle.update();
			}
		}
		
		// MOVE THE MAP AROUND TO MAKE IT LOOK LIKE YOUR WALKING
		private function backgroundMapUpdate():void {
			
			if (backgroundMapDirection != null) {
				
				if (backgroundMapDirection == "Right") {
				
					backgroundMap.x += this.speed;
					
					for (i = 0; i < obstaclesArray.length; i++) {
						
						obstaclesArray[i].x += this.speed;
					}
					
					for (var i = 0; i < beasts.length; i++) {
						
						if (beasts[i] != null) {
						
							beasts[i].x += this.speed;
						}
					}
				}
				
				if (backgroundMapDirection == "Left") {
					
					backgroundMap.x -= this.speed;
					
					for (i = 0; i < obstaclesArray.length; i++) {
						
						obstaclesArray[i].x -= this.speed;
					}
					
					for (i = 0; i < beasts.length; i++) {
						
						if (beasts[i] != null) {
							
							beasts[i].x -= this.speed;
						}
					}
				}
				
				if (backgroundMapDirection == "Up") {
					
					backgroundMap.y -= this.speed;
					
					for (i = 0; i < obstaclesArray.length; i++) {
						
						obstaclesArray[i].y -= this.speed;
					}
					
					for (i = 0; i < beasts.length; i++) {
						
						if (beasts[i] != null) {
							
							beasts[i].y -= this.speed;
					
						}
					}
				}
				
				if (backgroundMapDirection == "Down") {
					
					backgroundMap.y += this.speed;
					
					for (i = 0; i < obstaclesArray.length; i++) {
						
						obstaclesArray[i].y += this.speed;
					}
					
					for (i = 0; i < beasts.length; i++) {
						
						if (beasts[i] != null) {
							
							beasts[i].y += this.speed;
						}
					}
				}
			}			
		}
		
		// CHECK IF YOUR IN BATTLE
		private function battleCheck():void {
			
			if (characterInstance.getEnemyHit() == true) {
				
				battleBegun = true;
			}
		}
		
		// REMOVE THE BATTLE ON SCREEN (IS CALLED FROM BATLLESTAGE CLASS)
		public function removeBattleScene(_characterStats:Dictionary, _gameOver:Boolean, _gameWon:Boolean):void {
			
			battleBegun = false;
			gameWon = _gameWon;
			framesReady["Battle Scene"] = false;
			this.removeChild(battle);
			this.characterStats = _characterStats;
			gameOver = _gameOver;
			characterInstance.resetEnemyHit();
			battle = null;
			var enemyHit = characterInstance.getEnemy();			
			enemyHit.x = 90 + Math.random() * 1400;
			enemyHit.y = 100 + Math.random() * 1500;
			stage.focus = stage;
			togglePause();
		}
		
		// UPDATES THE STACKING ORDER OF ALL OBJECTS TO MAKE IT LOOK RIGHT
		private function stackingOrderSorting() {
			
			if (this.currentFrame != 3) {
				
				sortingArray.sortOn("y", Array.NUMERIC);
			
				//trace("ge");
					
				for (var i = sortingArray.length; i > 0; i--) {
					
					this.setChildIndex(sortingArray[i-1], i);
				}
			}
		}
		
		// POPULATES AN ARRAY OF OBSTACLES
		private function populateObstaclesArray() {
			
			for (var i = 0; i < this.numChildren; i++) {
				
				if (this.getChildAt(i) is BasicObstacle) {
					
					obstaclesArray.push(this.getChildAt(i));
					
					
				}
			}
			
			//trace("OBSTACLES_ARRAY_LENGTH: " + obstaclesArray.length);
		}
		
		// POPULATES AN ARRAY TO DEAL WITH STACKING ORDER
		private function populateSortingArray() {
			
			for (var i = 0; i < this.numChildren; i++) {
				
				if (this.getChildAt(i) is BasicObstacle || this.getChildAt(i) is BasicEnemy || this.getChildAt(i) is Character) {
						
					sortingArray.push(this.getChildAt(i));
				}
			}
		}
		
		// HANDLES PAUSEING THE GAME AND OPENING SKILLS MENU
		private function keyDownHandler(k:KeyboardEvent):void {
			
			if (k.keyCode == Keyboard.ESCAPE) {
				
				togglePause();
			}
			
			if (k.keyCode == Keyboard.S) {
				
				togglePause();
				
				if (gamePaused == true) {
					
					statUpScreen = new StatUpScreen(this, characterStats);
					statUpScreen.x = stage.stageWidth/2;
					statUpScreen.y = stage.stageWidth/2;
					this.addChild(statUpScreen);
				}
				
				if (gamePaused == false) {
					
					var _tempCharacterStats:Dictionary = statUpScreen.getCharacterStats();
					
					//trace(_tempCharacterStats);
					
					characterStats["characterHealth"] = _tempCharacterStats["characterHealth"];
					characterStats["characterAttack"] = _tempCharacterStats["characterAttack"];
					characterStats["characterDefend"] = _tempCharacterStats["characterDefend"];
					characterStats["characterExperience"] = _tempCharacterStats["characterExperience"];
					
					statUpScreen.removeListeners();
					this.removeChild(statUpScreen);
					statUpScreen = null;
					stage.focus = stage;
				}
			}
		}
		 
		// TOGGLES THE GAME PAUSE
		private function togglePause():void {
			
			gamePaused = !gamePaused;
		}
		
		// REMOVES EVENT LISTENERS
		private function removeEventListeners():void {
			
			stage.removeEventListener(Event.ENTER_FRAME, centralUpdate);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyDownHandler);
		}
	}
}
