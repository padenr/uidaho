#!/usr/local/bin/clisp

;; Paden Rumsey      CS 210
;; HW2               09-19-2015


(load "game.l")

(format t "~% ~%")
(format t "Welcome to LispStone! ~%")
(format t "This is the game that's all about the cards ~%")
(format t "A menu will appear that will ask you what you want to do. ~%")
(format t "Type the words exactly as they appear on the menu. ~%")
(format t "If quotes appear around any choices (play/attack) ignore them and ~%")
(format t "type the words exactly minus the quotes.")
(format t "~% ~%")


(setq maxEnergy 0)        ;;stores max energy of the current game turn
(setq pCardsOnBoard nil)  ;; variable to store cards that the player has played
(setq aiCardsOnBoard nil) ;;variable to store cards that the AI has played
(setq highestEnergy 0)    ;; keeps track of the highest energy card in a hand
(setq AINextCard nil)     ;;global that sets symbol as list that AI plays next
(setq JustOnBoard nil)    ;;global that keeps track of cards that have just been played by
                          ;; the AI and the player
(defun MainLoop ()
  (loop
   (setq maxEnergy (+ maxEnergy 1)) ;; increment  max energy
   (setq playerEnergy maxEnergy)    ;; set player energy
   (setq AIEnergy maxEnergy)        ;; set ai energy
   (setq userChoice (PlayerLoop))   ;;returns a value from the player loop (quit, end turn, Player loss, AI loss, etc...)
   (cond                            ;;end game or turn based on returned condition
     ((equal userChoice "Quit")
      (progn
	(format t "Player ended game ~%")
	(return-from MainLoop)))
     ((equal userChoice "End")
      (format t "Player ended turn ~% ~%"))
     ((equal userChoice "AI Loss") 
      (progn
	(format t "The AI has no more health. You WIN!!!!")
	(return-from MainLoop)))
     ((equal userChoice "Player Loss") 
      (progn 
	(format t "You have no more health. You lose")
	(return-from MainLoop))))
   (Transfer justOnBoard "pCardsOnBoard") ;;transfer cards that have been played to player board
   (setq justOnBoard nil)                 ;;reset just on board to nil
   (setq AIResults (AIloop))              ;;go to AI loop and get results (AIwins, player wins, etc..)
   (cond
    ((equal AIResults "AI Loss") 
     (progn
       (format t "The AI has no more health. You WIN!!!!!")
       (return-from MainLoop)))
    ((equal AIResults "Player Loss") 
     (progn
       (format t "You have no more health. You lose")
       (return-from MainLoop))))
    (Transfer justOnBoard "aiCardsOnBoard")
    (setq justOnBoard nil)))


;; this function is used to transfer the cards from the justonboard list to either the player
;; or ai onboard lists

(defun Transfer (transferredFrom transferredTo)
  (if (null transferredFrom) (return-from Transfer nil))
  (if (equal transferredTo "pCardsOnBoard") (setq pCardsOnBoard (AddtoList (car transferredFrom) pCardsOnBoard))
    (setq aiCardsOnBoard (AddtoList (car transferredFrom) aiCardsOnBoard)))
  (Transfer (cdr transferredFrom) transferredTo))
 

;;AI loop. Checks the victory conditions after each function call to see if theyve been met
;; if they have return with a string to check in main. if not. Continue until done. 

(defun AIloop()
  (MonsterAttacks aiCardsOnBoard)
  (if (<= AIHealth 0)
       (return-from AIloop PlayerLoop "AI Loss"))
  (if (<= Health 0)
      (return-from AIloop "Player Loss"))
  (AIPlayCards)
  (if (<= AIHealth 0)
      (return-from AIloop PlayerLoop "AI Loss"))
  (if (<= Health 0)
      (return-from AIloop "Player Loss"))
 
  )

;;funciton that attacks with the monsters that are on the board

(defun MonsterAttacks (L)
  (if (null L) (return-from MonsterAttacks)
    (progn
      (setq playerNum  (CountCards Hand))         ;; set variable to amount of cards in playerhand
      (setq randomChoice (random (1+ playerNum))) ;;set random choice to +1 # cards in playerhand
      (AttackPlayer (car L) randomChoice)         ;; go to attack player with attacking card choice
      (MonsterAttacks (cdr L)))))                 ;;if not at end of aicards on board continue 

;; if choice is greater than amount of player cards on board then attack player directly.
;; else attack the nth element of the players hand. This is a random choice
;; execute attack actually performs the attack

(defun AttackPlayer (attacking choice)
  (if (>= choice (CountCards pCardsonBoard))     
      (progn
    (format t "The AI attacks the player directly ~% ~%" )
    (setq Health (- Health (nth 3 attacking))))
    (progn
      (format t "The AI attacks ~a with ~b ~% ~%" (nth 2 (nth choice pCardsOnBoard)) (nth 2 attacking))
      (ExecuteAttack (nth choice pCardsOnBoard) attacking pCardsOnBoard "Hand"))))

;; if no card is less than the current AI energy then end the loop. Else set the card to
;; be played. Delete it from the Ai's hand. Determine if it's a health spell or offensive spell
;; or minion. If health call AIheal. if offensive attack player. if minion add to just on board
;; reset highest every time you go through the loop

(defun AIPlayCards ()
  (loop
   (if (= (FindHighestEnergy AIHand) 0) (return-from AIPlayCards)
     (progn
       (setq cardAIPlays AINextCard)
       (setq AIEnergy (- AIEnergy (nth 0 cardAIPlays)))
       (setq AIHand (DeletefromList cardAIPlays AIHand))
       (if (equal (nth 1 cardAIPlays) t)
       (if (> (nth 3 cardAIPlays) 0)
           (progn
         (setq randomChoice (random (1+ (CountCards aiCardsOnBoard))))
         (AttackPlayer cardAIPlays randomChoice))
         (AIHeal (nth 4 cardAIPlays) cardAIPlays))
     (progn
       (format t "The AI just placed ~a on the board ~% ~%" (nth 2 cardAIPlays))
       (setq justOnBoard (AddtoList cardAIPlays justOnBoard))))))
   (setq highestenergy 0)))

(defun AIHeal (healValue healCard)
  (if (equal (CountCards aiCardsOnBoard) nil)
      (setq cardAmount 0)
    (setq cardAmount (CountCards aiCardsOnBoard))) ;;set card amount
  (setq randomchoice (random (+ 1 cardAmount))) ;;add one to card amount
  (if (>= randomchoice cardAmount)  ;;heal the ai if the choice is greater than ai on board
      (progn
    (format t "Ai healed itself with ~a ~% ~%" (nth 2 healcard))
    (setq AIHealth (+ AIHealth healValue)))
    (ReplaceHealedAI healValue (nth randomchoice aiCardsOnBoard)))) ;;replace new healed card
                                                                    ;; with old
(defun ReplaceHealedAI (healValue cardToReplace)
  (setq aiCardsOnBoard (DeletefromList cardToReplace aiCardsOnBoard)) ;;delete old card
  (setf (nth 4 cardToReplace) (+ (nth 4 cardToReplace) healValue))  ;;add heal value to cardto
  (setq aiCardsOnBoard (AddtoList cardToReplace aiCardsOnBoard)))  ;;replace and add that to list
   
(defun FindHighestEnergy (L)
  (if (null L) (return-from FindHighestEnergy highestenergy) ;;return the highest energy found
    (if (<= (nth 0 (car L)) AIEnergy)                       ;; if none return 0 by default
    (if (> (nth 0 (car L)) highestEnergy)                   ;; if energy is not greater than the AI's
        (progn 
          (setq AINextCard (car L))
          (setq highestEnergy (nth 0 (car L)))) ;; if energy is less than AI's total and more
      (FindHighestEnergy (cdr L)))              ;; than previous card (default 0) then set
      (FindHighestEnergy (cdr L)))))            ;; as highest energy card and highest energy
   

(defun CountCards (L)
  (if (null L) (return-from CountCards 0) ;;counts all the lists in the main hand
      (if (equal (listp (car L)) t)
      (1+ (CountCards (cdr L))))))


;; check the player victory/loss conditions. If not met then ask user for input
;; then play card attack quit or end turn based on that


(defun PlayerLoop ()
  (loop
   (if (<= AIHealth 0)
       (return-from PlayerLoop "AI Loss"))
   (if (<= Health 0)
       (return-from PlayerLoop "Player Loss"))
   (format t "~% ~%")
   (PrintGameState)
    (format t "What action would you like to take? ~% Quit ~% End ~% Play ~% Attack ~% ~%")
    (setq x (read-line))
    (format t "~%")
    (cond
     ((equal x "Quit")   (return-from playerloop "Quit"))
     ((equal x "End" )   (return-from playerloop "End"))
     ((equal x "Play")
      (progn
    (format t "Who would you like to play? ~% ~%")
    (PrintHand Hand)
    (format t "~% ~%")
    (setq play (read-line))
    (PlayCard play Hand))) 
     ((equal x "Attack")
      (progn
    (format t "Who would you like to attack with? ~% ~%")
    (if (> (CountCards pCardsOnBoard) 0)
        (progn
          (PrintHand pCardsOnBoard)
          (format t "~%")
          (setq attacker (read-line))
          (format t "Who would you like to attack? ~% ~%")
          (format t "AI")
          (PrintHand aiCardsonBoard)
          (format t "~% ~%")
          (setq attacked (read-line))
          (Attack attacked attacker pCardsOnBoard aiCardsOnBoard))
      (format t  "You do not have any cards to play ~% ~%"))))
     ((equal t t) (format t "There is no action with that name ~% ~%")))))
     
(defun PlayCard (cardName L)
  (if (null L)
      (progn
	(format t "Card not found in playable hand. Did you spell them correctly? Did you just place the card this turn? ~% ~%")
	(return-from PlayCard)))
  (if (equal (IsCard cardName (car L)) t) ;;is the card in the sublist? 
      (if (<= (caar L) playerEnergy)      ;; is the card less than the player's total energy
	  (if (equal (cadar L) t)         ;; is it a spell card?
          (if (> (nth 4 (car L)) 0)  ;; is it offensive spell or heal
	      (progn ;;heal card. print choices then chose subtract energy, delet from hand
		(format t "Heal Card. Who would you like to heal? ~% ~%")
		(format t "Player ~%")
		(PrintHand pCardsOnBoard)
		(setq toBeHealed (read-line))
		(setq cost (nth 0 (car L)))
		(setq playerEnergy (- playerEnergy cost))
		(setq Hand (DeletefromList (car L) Hand))
		(Heal (nth 4 (car L)) toBeHealed pCardsOnBoard))
	    (progn ;;offensive card. Print attack choices. subtrace cost. Delete from hand
	      (format t "Offensive Spell Card. Who would you like to attack? ~%")
	      (format t "AI~%")
	      (PrintHand aiCardsOnBoard)
	      (setq attacked (read-line))
	      (setq cost (nth 0 (car L)))
	      (setq playerEnergy (- playerEnergy cost))
	      (setq Hand (DeletefromList (car L) Hand))
	      (AttackSpell attacked (car L) pCardsOnBoard AICardsOnBoard)))
	  (PlaceCard (car L))) ;;place card if not spell
	(progn
	  (format t "You do not have enough energy for that ~% ~%") 
	  (return-from PlayCard))) ;;return if not enough energy
    (PlayCard cardName (cdr L))))

(defun Heal (healAmount toBeHealed minionList)
  (if (equal toBeHealed "Player")    ;;heal player health if chosen
      (progn
	(setq Health (+ Health healAmount))
	(return-from Heal)))
  (if (null minionList) ;;check to see if heal target exists
      (progn
    (format t "Healing target does not exist. Did you spell it correctly? ~% ~%")
     (return-from Heal))
    (if (equal (IsCard toBeHealed (car minionList)) t) ;;if exists then replaced the card in hand
        (ReplaceHealedPlayer healAmount (car minionList)) ;;with new healed card
      (Heal healAmount toBeHealed (cdr minionList))))) ;;else recursively call if not end of check


(defun ReplaceHealedPlayer (healValue cardToReplace)
  (setq pCardsOnBoard (DeletefromList cardToReplace pCardsOnBoard)) ;;same as replce healed ai
  (setf (nth 4 cardToReplace) (+ (nth 4 cardToReplace) healValue))
  (setq pCardsOnBoard (AddtoList cardToReplace pCardsOnBoard)))


(defun PrintHand(L) ;;Print cards in hand
  (if (null L) (format nil "End of Player Cards ~% ~%")
    (progn
      (print (caddar L))
      (PrintHand (cdr L)))))

;; no need to precheck if attacking exists is spell the checking is already done

(defun AttackSpell (attacked attacker attackingHand attackedHand)
  (format t "~a" attacked)
  (if (equal attacked "AI") ;;if the target is ai then print message and subtract attack
      (progn
    (format t " ~% ~a attacks the Ai ~% ~%" (nth 2 attacker))
    (setq AIHealth (- AIHealth (nth 3 attacker)))
    (return-from AttackSpell)))
  (if (null attackedhand) ;;if at end the target card doesn't exist
      (progn
    (format t "The card you want to attack does not exist. Did you spell it correctly? ~% ~%")
    (return-from AttackSpell)) ;;return 
    (if (equal (IsCard attacked (car attackedHand)) t)
    (progn ;; execute attack if target exists and not AI
      (format t "The player attacks ~a with ~b ~% ~%" (nth 2 (car attackedHand)) (nth 2 attacker))
      (ExecuteAttack (car attackedHand) attacker aiCardsOnBoard "AIHand"))
      (Attack attacked attacker attackingHand (cdr attackedhand)))))

;; same things at attack spell except there is one more nested if that checks to see if the
;; attacking card exists. If both the attacker and the attacking exist then call execute attack
;; if the target is the AI then execute attack is never called

(defun Attack (attacked attacker attackingHand attackedHand)
  (if (null attackingHand)
      (progn
	(format t "The attacking card does not exist. Did you spell it correctly? Did you just play it this turn? ~% ~%")
	(return-from Attack)))
  (if (equal (IsCard attacker (car attackingHand)) t)
      (progn
	(if (equal attacked "AI")
	    (progn
	      (format t " ~% ~a attacks the Ai ~% ~%" attacker)
	      (setq AIHealth (- AIHealth (nth 3 (car attackingHand))))
	      (return-from Attack)))
	(if (null attackedhand)
	      (progn
		(format t "The enemy you want to attack does not exist. Did you spell it correctly? ~% ~%")
		(return-from Attack))
	  (if (equal (IsCard attacked (car attackedHand)) t)
	      (progn
		(ExecuteAttack (car attackedHand) (car attackingHand) aiCardsOnBoard "AIHand")
		(return-from Attack))
	    (Attack attacked attacker attackingHand (cdr attackedhand))))
	(Attack attacked attacker (cdr attackingHand) attackedHand))))

;; set variable to new health value of target card. Delete original target from attackedHand
;; can't delete before setting newvalue or you lose the new health value. Set card health to
;; new value and then if its above zero then add it back to the hand. DO not add if below zero
;; if below zero print message its been destoroyed. if above zero add to aihand or hand depending
;; on whichGlobal is either Hand or AIHand

(defun ExecuteAttack (attacked attacker attackedHand whichGlobal)
  (setq newValue (- (nth 4 attacked) (nth 3 attacker)))
  (setq attackedHand (DeletefromList attacked attackedHand))
  (setf (nth 4 attacked) newValue)
  (if (<= (nth 4 attacked) 0)
      (format t "The monster/minion ~a was destroyed ~% ~%" (nth 2 attacked))
    (setq attackedHand (AddtoList attacked attackedHand)))
  (if (equal whichGlobal "Hand")
      (progn
    (setq pCardsOnBoard attackedHand))
    (progn
      (setq aiCardsOnBoard attackedHand))))

;; checks to see if attacked card exists. Not used in this program

(defun AttackedExists(attacked L)
  (if (null L)
      (progn
    (format t "The card you want to attack does not exist. Did you spell it correctly? ~% ~%")
    (return-from AttackedExists))
    (if (equal (IsCard attacked (car L)) t) car L
    (AttackedExists attacked (cdr L)))))


;; print game state

(defun PrintGameState ()
  (format t "Player Health:                  ~a ~%" Health)
  (format t "Player Energy:                  ~a ~%" playerEnergy)
  (format t "Minions you can use next turn:  ~a ~%" JustOnBoard)
  (format t "Minions you can use this turn:  ~a ~%" pCardsOnBoard)
  (format t "Player cards in hand:           ~a ~% ~%" Hand)
  (format t "Enemy Minions in Hand           ~a ~%" AiHand)
  (format t "Current AI Health:              ~a ~%" AIHealth)
  (format t "Current AI Energy:              ~a ~%" AIEnergy)
  (format t "Enemy cards on the board:       ~a ~% ~%" aiCardsOnBoard)

  )

;; checks and LIST ELEMENT that is passed to it to see if its a card. Whole hand is not passed
;; just individual cards. 
           
(defun IsCard (card L)
    (if (null L) nil
    (if (equal (car L) card) (return-from IsCard t)
        (IsCard card (cdr L) ))))

;;deletes the card from the hand and adds it to just on board.

(defun PlaceCard (card)
  (setq playerEnergy (- playerEnergy (car card)))
  (setq Hand (DeletefromList card Hand))
  (setq justOnBoard (AddtoList card justOnBoard))
  )

;; add a card to a Hand

(defun AddtoList (card hand)
    (if (null hand) (return-from AddtoList (cons card nil)))
    (cons (car hand) (AddtoList card (cdr hand))))


;; deletes card from hand

(defun DeletefromList (card hand)
  (if (null hand) nil
    (if (equal card (car hand))
    (if (equal (cadr hand) nil) nil
      (cons (cadr hand) (DeletefromList card (cddr hand))))
      (cons (car hand) (DeletefromList card (cdr hand))))))


(mainloop)