package  {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MainGame extends MovieClip {
		
		private var firstCard:RedCard;
		private var secondCard:RedCard;
		private var cards:Array;
		private var cardsReal:Array;
		
		private var isInOneLink:Boolean;
		private var isInTwoLink:Boolean;
		
		private var timer:Timer;
		private var link:Shape;
		
		private var timerBar:Sprite;
		private var clock:Timer;
		
		private var gameScoreText:TextField;
		private var gameScore:uint;
		
		private var tempNodeForOne:RedCard;
		private var tempNodeForTwo_1:RedCard;
		private var tempNodeForTwo_2:RedCard;

		public function MainGame() {
			InitGame();
		}	
		
		private function InitGame() {
			InitCards();
			isInOneLink = false;
			isInTwoLink = false;
			
			timerBar = new Sprite();
			timerBar.graphics.beginFill(0xffff00, 1);
			timerBar.graphics.drawRect(0, 0, 600, 20);
			timerBar.graphics.endFill();
			timerBar.x = 300;
			timerBar.y = 10;
			addChild(timerBar);
			clock = new Timer(200, 1000);
			clock.addEventListener(TimerEvent.TIMER, minusClock);
			clock.addEventListener(TimerEvent.TIMER_COMPLETE, loseGame);
			clock.start();
			
			gameScore = 0;
			gameScoreText = new TextField();
			gameScoreText.width = 250;
			gameScoreText.height = 24;
			gameScoreText.x = 20;
			gameScoreText.y = 10;
			var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0xeeeeee;
            format.size = 16;
			gameScoreText.defaultTextFormat = format;
			gameScoreText.text = "消防安全在我心中  得分：" + String(gameScore);
			addChild(gameScoreText);
			
			
		}
		
		private function InitCards() {
			cards = new Array();
			cardsReal = new Array();
			var card_frames:Array = new Array();
			var card_frame:uint = Math.floor((Math.random() * 30)) + 1;
			card_frames.push(card_frame);
			while (card_frames.length != 11) {
				card_frame = Math.floor((Math.random() * 30)) + 1;
				for (var j:uint = 0; j < card_frames.length; j++) {
					if (card_frames[j] == card_frame) 
						break;
					if (j == card_frames.length - 1)
						card_frames.push(card_frame);
				}
			}
		
			var card1_array  = new Array(card_frames[0],  10);
			var card2_array  = new Array(card_frames[1],  10);
			var card3_array  = new Array(card_frames[2],  10);
			var card4_array  = new Array(card_frames[3],  10);
			var card5_array  = new Array(card_frames[4],  10);
			var card6_array  = new Array(card_frames[5],  8);
			var card7_array  = new Array(card_frames[6],  8);
			var card8_array  = new Array(card_frames[7],  8);
			var card9_array  = new Array(card_frames[8],  8);
			var card10_array = new Array(card_frames[9],  8);
			var card11_array = new Array(card_frames[10], 8);
			
			cards.push(card1_array);
			cards.push(card2_array);
			cards.push(card3_array);
			cards.push(card4_array);
			cards.push(card5_array);
			cards.push(card6_array);
			cards.push(card7_array);
			cards.push(card8_array);
			cards.push(card9_array);
			cards.push(card10_array);
			cards.push(card11_array);
			
			for (var y:uint = 0; y < 9; y++) {
				for (var x:uint = 0; x < 16; x++) {
					var card:RedCard = new RedCard();
					if (y >= 1 && y <= 7 && x >= 1 && x <= 14) {
						var id:uint = (uint)(Math.random() * 11);
						while (cards[id][1] == 0) {
							var isDone = false;
							id = (uint)(Math.random() * 11);
							for (var k:uint = 0; k < 10; k++) {
								if (cards[k][1] != 0)
									break;
								if (k == 10)
									isDone = true;
							}
							if (isDone)
								break;
						}
						card.gotoAndStop(cards[id][0]);
						card.id = cards[id][0];
						cards[id][1]--;
						card.x_index = x;
						card.y_index = y;
						card.x = (x - 1) * 65 + 20;
						card.y = (y - 1) * 83 + 50;
						card.addEventListener(MouseEvent.CLICK, cardClick);
						cardsReal.push(card);
						addChild(card);					
					} else {
						card.gotoAndStop(31);
						card.x_index = x;
						card.y_index = y;
						card.state = 0;
						card.x = (x - 1) * 65 + 20;
						card.y = (y - 1) * 83 + 50;
						cardsReal.push(card);
						addChild(card);		
					}
					
				}
			}
		}
		
		private function cardClick(event:MouseEvent) {
			var thisCard:RedCard = (event.target as RedCard); // what card?
			thisCard.border.visible = true;
			if (firstCard == null) { // first card in a pair
				firstCard = thisCard; // note it
				//playSound(theFirstCardSound);
				
			} else if (firstCard == thisCard) { // clicked first card again
				firstCard = null;
				thisCard.border.visible = false;
				//playSound(theMissSound);
				
			} else if (secondCard == null) { // second card in a pair
				secondCard = thisCard; // note it
					
				if (isLink(firstCard, secondCard)) {					
					firstCard.gotoAndStop(31);
					secondCard.gotoAndStop(31);
					firstCard.state = 0;
					secondCard.state = 0;
					firstCard.border.visible = false;
					secondCard.border.visible = false;
					firstCard = null;
					secondCard = null;
					gameScore += 100;
					gameScoreText.text = "消防安全在我心中  得分：" + gameScore;
					if (gameScore == 4900) {
						clock.removeEventListener(TimerEvent.TIMER, minusClock);
						clock.removeEventListener(TimerEvent.TIMER_COMPLETE, loseGame);
						clock = null;
						cards = null;
						cardsReal = null;
						removeChildren();
						gotoAndStop(3);
						replayBtn.addEventListener(MouseEvent.CLICK, replay);
					}
				} else {
					firstCard.border.visible = false;
					secondCard.border.visible = false;
					firstCard = null;
					secondCard = null;
				}
			}
		}
		
		private function cardHide(event:TimerEvent) {
			removeChild(link);
		}
		
		private function minusClock(event:TimerEvent) {
			timerBar.scaleX -= 0.001;
		}
		private function loseGame(event:TimerEvent) {	
			clock.removeEventListener(TimerEvent.TIMER, minusClock);
			clock.removeEventListener(TimerEvent.TIMER_COMPLETE, loseGame);
			clock = null;
			cards = null;
			cardsReal = null;
			removeChildren();
			gotoAndStop(2);
			replayBtn.addEventListener(MouseEvent.CLICK, replay);
		}
		
		private function replay(event:MouseEvent) {
			removeChildren();
			gotoAndStop(1);
			InitGame();
		}
		
		private function isLink(card1:RedCard, card2:RedCard):Boolean {
			
			if (isZeroLink(card1, card2)) {
				link = new Shape();
				link.graphics.moveTo(card1.x + 30, card1.y + 40);
				link.graphics.lineStyle(3, 0xffff00);
				link.graphics.lineTo(card2.x + 30, card2.y + 40);
				this.addChild(link);
				
				timer = new Timer(100, 1);
				timer.addEventListener(TimerEvent.TIMER, cardHide);
				timer.start();
				return true;
			} else if (isOneLink(card1, card2)) {
				link = new Shape();
				link.graphics.moveTo(card1.x + 30, card1.y + 40);
				link.graphics.lineStyle(3, 0xffff00);
				link.graphics.lineTo(tempNodeForOne.x + 30, tempNodeForOne.y + 40);
				link.graphics.lineTo(card2.x + 30, card2.y + 40);
				this.addChild(link);
				
				timer = new Timer(100, 1);
				timer.addEventListener(TimerEvent.TIMER, cardHide);
				timer.start();
				return true;
			} else if (isTwoLink(card1, card2)) {
				link = new Shape();
				link.graphics.moveTo(card1.x + 30, card1.y + 40);
				link.graphics.lineStyle(3, 0xffff00);
				link.graphics.lineTo(tempNodeForTwo_1.x + 30, tempNodeForTwo_1.y + 40);
				link.graphics.lineTo(tempNodeForTwo_2.x + 30, tempNodeForTwo_2.y + 40);
				link.graphics.lineTo(card2.x + 30, card2.y + 40);
				this.addChild(link);
				
				timer = new Timer(100, 1);
				timer.addEventListener(TimerEvent.TIMER, cardHide);
				timer.start();
				return true;
			}
			return false;
		}
		
		private function isZeroLink(card1:RedCard, card2:RedCard):Boolean {
			var c1:RedCard;
			var c2:RedCard;
			if (card1.x_index == card2.x_index) {
				if ((Math.abs(card1.y_index - card2.y_index) == 1) &&
					((card1.currentFrame == card2.currentFrame) || 
				     ((isInOneLink || isInTwoLink) && (card1.state == 0 || card2.state == 0))))
					return true;
				if (card1.y_index < card2.y_index) {
					c1 = card1;
					c2 = card2;
				} else {
					c1 = card2;
					c2 = card1;
				}
				for (var i:uint = c1.y_index + 1; i < c2.y_index; i++) {
					if (cardsReal[16 * i + c1.x_index].currentFrame != 31) 
						break;
					if (i == c2.y_index - 1 && ((c1.currentFrame == c2.currentFrame) || 
				     ((isInOneLink || isInTwoLink) && (c1.state == 0 || c2.state == 0))))
						return true;
				}
			} else if (card1.y_index == card2.y_index){
				if ((Math.abs(card1.x_index - card2.x_index) == 1) &&
					((card1.currentFrame == card2.currentFrame) || 
				     ((isInOneLink || isInTwoLink) && (card1.state == 0 || card2.state == 0))))
					return true;
				if (card1.x_index < card2.x_index) {
					c1 = card1;
					c2 = card2;
				}
				else {
					c1 = card2;
					c2 = card1;
				}
				
				for (var j:uint = c1.x_index + 1; j < c2.x_index; j++) {
					if (cardsReal[16 * c1.y_index + j].currentFrame != 31) 
						break;
					if (j == c2.x_index - 1 && ((c1.currentFrame == c2.currentFrame) || 
				     ((isInOneLink || isInTwoLink) && (c1.state == 0 || c2.state == 0))))
						return true;
				}
			}
			return false;
		}
		
		private function isOneLink(card1:RedCard, card2:RedCard):Boolean {
			isInOneLink = true;
			if ((card1.currentFrame == card2.currentFrame) || 
				((isInTwoLink) && (card1.state == 0 || card2.state == 0))) {
				var c1:RedCard;
				var c2:RedCard;
				var c3:RedCard;
				var c4:RedCard;
				if (card1.x_index > card2.x_index) {
					c1 = card2;
					c3 = card1;
				} else {
					c1 = card1;
					c3 = card2;
				}
				c2 = cardsReal[c1.y_index * 16 + c3.x_index];
				c4 = cardsReal[c3.y_index * 16 + c1.x_index];
				if (isZeroLink(c1, c2) && isZeroLink(c2, c3)) {
					if (isInTwoLink) {
						tempNodeForTwo_2 = c2;
					}
					tempNodeForOne = c2;
					return true;
				} else if (isZeroLink(c1, c4) && isZeroLink(c4, c3)) {
					if (isInTwoLink) {
						tempNodeForTwo_2 = c4;
					}
					tempNodeForOne = c4;
					return true;
				}

			}
			isInOneLink = false;
			return false;			
		}
		
		private function isTwoLink(card1:RedCard, card2:RedCard):Boolean {
			isInTwoLink = true;
			if (card1.currentFrame == card2.currentFrame) {
				var tempCard:RedCard;
				for (var i:uint = 0; i < 16; i++) {
					tempCard = cardsReal[card1.y_index * 16 + i];
					if (isZeroLink(tempCard, card1) && isOneLink(tempCard, card2)) {
						tempNodeForTwo_1 = tempCard;
						return true;
					}
					if (i == 15)
						break;
				}
				for (var j:uint = 0; j < 9; j++) {
					tempCard = cardsReal[j * 16 + card1.x_index];
					if (isZeroLink(tempCard, card1) && isOneLink(tempCard, card2)) {
						tempNodeForTwo_1 = tempCard;
						return true;
					}
					if (j == 8)
						break;
				}
			}
			isInTwoLink = false;
			return false;
		}
		
		private function drawLink(card1:RedCard, card2:RedCard) {
			
		}
	}
	
	
}








