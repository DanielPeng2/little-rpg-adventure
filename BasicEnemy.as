package {
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.text.engine.EastAsianJustifier;
	
	public class BasicEnemy extends MovieClip {
		
		// LENGTH OF MOVEMENT BEFORE DIRECTION CHANGE
		private var moveLength:int = 32;
		
		// # OF DIRECTION CHANGES BEFORE REVALUATION
		private var moveTimes:int = 4;
		
		// ENEMY STATE BOOLEANS
		private var moveMe:Boolean = false;
		private var startMovement:Boolean = true;
		
		// ENEMY MOVEMENT DIRECTION
		private var dir:String = "Down";
		
		// BOOLEAN CONTROLLS THE SELECTION OF A NEW DIRECTION
		private var newDirectionNeeded:Boolean = true;
		
		// TIMER USED FOR IDLING
		private var timer:Timer;
		
		// OBJECT CONTAINING THE OBSTACLES (TREES)
		private var obstaclesArray;
		
		// HIT TEST POINTS
		protected var leftPoint:Point = new Point();
		protected var rightPoint:Point = new Point();
		protected var upPoint:Point = new Point();
		protected var downPoint:Point = new Point();
		
		// HIT TEST BOOLEANS
		private var leftClear:Boolean = true;
		private var rightClear:Boolean = true;
		private var upClear:Boolean = true;
		private var downClear:Boolean = true;
		
		private var leftDot = new Dot();
		private var rightDot = new Dot();
		private var upDot = new Dot();
		private var downDot = new Dot();
		
		// TYPE OF ENEMY (RAT || OGRE)
		private var enemyType:String = null;
		
		
		// STORES A REFERENCE TO THE MAIN CLASS
		private var docClass:Main;
		
		public function BasicEnemy(_obstaclesArray:Array = null, _enemyType:String = null, _docClass:Main = null) {
			
			// ASSIGN CONTRUCTOR ARGUMENTS TO LOCAL VARIABLES
			this.obstaclesArray = _obstaclesArray;
			this.enemyType = _enemyType;
			this.docClass = _docClass;
			
			// IF THE ENEMY WASN'T USED FOR A BATTLE
			if (!this.parent is BattleStage) {
				
				// WAIT TILL THE ENEMY IS ADDED TO THE STAGE
				this.addEventListener(Event.ADDED_TO_STAGE, constructorFunc);
			}
		}	
		
		public function constructorFunc(e:Event) {
			
			// CHECK IF THE ENEMY IS TOUCHING SOMETHING
			hitDetection();
			
			// MOVE THE ENEMY AROUND UNTIL ITS NOT TOUCHING SOMETHING
			while(leftClear == false || rightClear == false || upClear == false || downClear == false) {
				
				hitDetection();
				
				trace("hit");
				
				this.x = 90 + Math.random() * 1400;
				this.y = 100 + Math.random() * 1500;
			}
		}
		
		// UPDATE FUNCTION
		public function update() {
			
			// UPDATE HIT TEST POINTS
			if (enemyType == "rat") {
			
				this.leftPoint.x = this.x - this.width / 2;
				this.leftPoint.y = this.y - this.height / 2;
				this.rightPoint.x = this.x + this.width / 2;
				this.rightPoint.y = this.y - this.height / 2;
				this.upPoint.x = this.x;
				this.upPoint.y = this.y - this.height;
				this.downPoint.x = this.x;
				this.downPoint.y = this.y;
			}
			
			// OGRES AND SKELTONS NEED TO BE ABLE TO WALK UP TO BUILDINGS
			if (enemyType == "ogre" || enemyType == "skeleton") {
				
				this.leftPoint.x = this.x - this.width / 2;
				this.leftPoint.y = this.y - this.height / 6;
				this.rightPoint.x = this.x + this.width / 2;
				this.rightPoint.y = this.y - this.height / 6;
				this.upPoint.x = this.x;
				this.upPoint.y = this.y - this.height / 3;
				this.downPoint.x = this.x;
				this.downPoint.y = this.y;
			}
			
			// IF YOUR NOT BATTLING THE BOSS
			if (enemyType != "deathLord") {
			
				// CALL HIT DETECTION
				hitDetection();
				
				// RANDOM #
				var rand = Math.random();
				
				if (startMovement == true) {
				
					startMovement = false;
					
					// DECIDE WHETHER TO MOVE OR IDLE
					if (rand > 0.5) {
						
						// DECIDE TO MOVE
						moveMe = true;
					}
					
					if (rand < 0.5) {
						
						// DECIDE TO IDLE
						moveMe = false;
						
						// TIME HOW LONG YOU'VE BEEN IDLING
						timer = new Timer(2000, 0);
						timer.addEventListener("timer", idleDone);
						timer.start();
					}
				}
				
				// IF YOU DECIDED TO IDLE
				if (moveMe == false) {
					
					// IDLE IN THE DIRECTION YOU WERE JUST WALKING IN
					
					if (dir == "Right") {
						
						this.gotoAndStop("IdleRight");
					}
					if (dir == "Up") {
						
						this.gotoAndStop("IdleUp");
					}
					if (dir == "Down") {
						
						this.gotoAndStop("IdleDown");
					}
					if (dir == "Left") {
						
						this.gotoAndStop("IdleLeft");
					}
				}
				
				// IF YOU DECIDED TO MOVE
				else if (moveMe == true) {
					
					rand = Math.random();
					
					// RANDOMLY PICK A NEW DIRECTION
					if (newDirectionNeeded == true) {
						
						newDirectionNeeded = false;
						
						if (rand <= 0.25 && leftClear == true) {
							
							dir = "Left";
						}
						
						else if (rand > 0.25 && rand <= 0.5 && rightClear == true) {
							
							dir = "Right";
						}
						
						else if (rand > 0.5 && rand <= 0.75 && upClear == true) {
							
							dir = "Up";
						}
						
						else if (rand > 0.75 && rand <= 1 && downClear == true) {
							
							dir = "Down";
						}
					}
					
					// MOVE AND ANIMATE IN THAT DIRECTION
					if (dir == "Right" && rightClear == true) {
						
						this.x += 1;
						moveLength--;
						this.gotoAndStop("WalkRight");
					}
					
					if (dir == "Right" && rightClear == false) {
						
						this.gotoAndStop("IdleRight");
						moveLength--;
					}
					
					if (dir == "Left" && leftClear == true) {
						
						this.x -= 1;
						moveLength--;
						this.gotoAndStop("WalkLeft");
					}
					
					if (dir == "Left" && leftClear == false) {
						
						this.gotoAndStop("IdleLeft");
						moveLength--;
					}
					
					if (dir == "Up" && upClear == true) {
						
						this.y -= 1;
						moveLength--;
						this.gotoAndStop("WalkUp");
					}
					
					if (dir == "Up" && upClear == false) {
						
						this.gotoAndStop("IdleUp");
						moveLength--;
					}
					
					if (dir == "Down" && downClear == true) {
						
						this.y += 1;
						moveLength--;
						this.gotoAndStop("WalkDown");
					}
					
					if (dir == "Down" && downClear == false) {
						
						this.gotoAndStop("IdleDown");
						moveLength--;
					}
					
					// ONCE YOU'VE MOVED FAR ENOUGH
					if (moveLength <= 0) {
						
						// RESET MOVE LENGTH
						moveLength = 32;
						moveTimes--;
						newDirectionNeeded = true;
						
						// UNTIL YOU'VE MOVED ENOUGH TIMES
						if (moveTimes <= 0) {
							
							// THEN DECIDE TO MOVE OR IDLE
							moveTimes = 4;
							startMovement = true;
						}
					}
				}
			}
			
			// IF THE ENEMY IS THE BOSS
			if (enemyType == "deathLord") {
				
				// DONT MOVE AROUND AND JUST IDLE IN PLACE
				this.gotoAndStop("IdleDown");
			}
		}
		
		// FUNCTION HANDELS IDLE TIMERS
		private function idleDone(t:TimerEvent) {
			
			timer.removeEventListener("timer", idleDone);
			startMovement = true;
			timer.reset();
			timer.addEventListener("timer", idleDone);
			timer.start();
			
		}
		
		// HIT DETECTION
		private function hitDetection() {
			
			// CYCLE THROUGH ARRAY OF OBSTACLES
			for (var i = 0; i < obstaclesArray.length; i++) {
				
				// CURRENT OBSTACLE
				var currentObjectMC = obstaclesArray[i];
				
				// LITTLE SQUARE IN EVERY OBSTACLE DEFINING WHERE YOU CAN'T WALK
				var currentObject = currentObjectMC.hitTestSquare;
				
				// IF YOU OBSTACLE EXISTS
				if (currentObject != undefined) {
					
					// AND YOUR TOUCHING IT
					if (this.hitTestObject(currentObject)) {
							
						// CHECK TO SEE WHICH POINTS ARE TOUCHING THE OBSTACLE
						if (currentObject.hitTestPoint(leftPoint.x, leftPoint.y, true) || currentObject.hitTestPoint(leftPoint.x, this.y, true)) {
							
							// AND ALTER MOVEMENT BOOLEANS ACCORDINGLY 
							leftClear = false;
							leftDot.gotoAndStop(2);
						}
						
						if (currentObject.hitTestPoint(rightPoint.x, rightPoint.y, true) || currentObject.hitTestPoint(rightPoint.x, this.y, true)) {
							
							rightClear = false;
							rightDot.gotoAndStop(2);
						}
						
						if (currentObject.hitTestPoint(upPoint.x, upPoint.y, true)) {
							
							upClear = false;
							upDot.gotoAndStop(2);
						}
						
						if (currentObject.hitTestPoint(downPoint.x, downPoint.y, true)) {
							
							downClear = false;
							downDot.gotoAndStop(2);
						}
		
						// YOUR NOT GOING TO BE TOUCHING ALL OBJECTS, SO WHEN YOU'VE FOUND THE ONE YOUR TOUCHING GET OUT
						// (THERE IS A BETTER WAY TO DO THIS. SEE CHARACTER HIT TESTING. ITS LESS EFFICIENT THOUGH
						return;
					}
					
					// IF YOUR NOT TOUCHING THE OBJECT
					else if (!this.hitTestObject(currentObject)) {
						
						// UPDATE POINTS THAT ARE NOT BEING TOUCHED (DIRECTIONS YOU CAN WALK IN)
						if (!currentObject.hitTestPoint(leftPoint.x, leftPoint.y, true) || !currentObject.hitTestPoint(leftPoint.x, this.y, true)) {
							
							leftClear = true;
							leftDot.gotoAndStop(1);
						}
						
						if (!currentObject.hitTestPoint(rightPoint.x, rightPoint.y, true) || !currentObject.hitTestPoint(rightPoint.x, this.y, true)) {
							
							rightClear = true;
							rightDot.gotoAndStop(1);
						}
						
						if (!currentObject.hitTestPoint(upPoint.x, upPoint.y, true)) {
							
							upClear = true;
							upDot.gotoAndStop(1);
						}
						
						if (!currentObject.hitTestPoint(downPoint.x, downPoint.y, true)) {
							
							downClear = true;
							downDot.gotoAndStop(1);
						}
					}
				}
			}
		}
	}
}