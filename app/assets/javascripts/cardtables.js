var CP = ( function(){
     var table = {};
     return {
	 stacks: {},
	 all_cards: {},
	 how_many: 0,
         // for movie effect
	 postopone: function(move,time){
	     setTimeout(function(){ 
		 CP[move.action].apply(CP,move.params);},time);	     
	 },
	 
	 play: function(moves,time){
	     for ( var i = 0; i< moves.length ; i++) {
		 move = moves[i];
		 CP.postopone(move,time);
	     };
	 },
	 
	 from_stack_move: function(stack_from,i,stack_to){
	     card = CP.stacks[stack_from].cards[i];
	     CP.move_card(stack_from,i,CP.stacks[stack_to].xnext,CP.stacks[stack_to].ynext,CP.stacks[stack_to].znext);
	     newstack = CP.stacks[stack_to];
	     card.stack_id = stack_to;
	     card.in_stack_pos =newstack.cards.length;
	     newstack.cards[newstack.cards.length] = card;
	     newstack.update_next_pos();
	     CP.stacks[stack_to]=newstack;
	 },
	 create_stack: function(stack_id,
				stack_type,
				xpos,
				ypos,
				pixdist,
				positions){
	     this.stacks[stack_id] = Stack.create(stack_id,
					     stack_type,
					     xpos,
					     ypos,
					     pixdist,
					     positions,this.get_table());
	 },
	 move_card: function(stack_id,i,px,py,pz){
	     CP.stacks[stack_id].cards[i].move_to(px,py,pz);
	     CP.stacks[stack_id].remove_card(i,true);
	 },

	 create_table: function(ele,pxsize){
	     table = {
		 parent: ele,
		 pxsize: pxsize
	     };
	     ele.css({"font-size": pxsize+'px' }); 
	     ele.css({position: 'relative'});
	     return table;
	 },

	 get_pxsize: function(){
	     return table.pxsize;
	 },

	 add_card_to_stack: function(stack_id,card_id,show){
	     c = Cards.create_card(card_id);
	     c.stack_id = stack_id;
	     CP.stacks[stack_id].add_card(c);
	     if (show === true ) {
		 CP.show_stack(stack_id);
	     }
	 },

	 flip_card: function(stack_id,i,card_id){
	     card = CP.stacks[stack_id].cards[i];
	     CP.stacks[stack_id].remove_card(i,true);
	     card.get_div().hide();
	     CP.add_card_to_stack(stack_id,card_id,true);
	 },

	 show_stack: function(stack_id) {
	     CP.stacks[stack_id].show();
	 },

	 get_table: function(){
	     return table.parent;
	 },
	 // optimal size is 5px 
	 // every other position will scale

	 scale: function(x) {
	     return x* (this.get_pxsize() / 5)
	 },
	 get_stacks: function(){
	     $.ajax({
		 type: "GET",
		 contentType: "application/json; charset=utf-8",
		 url: "/games/stacks",
		 data : JSON.stringify({what:"stacks"}),
		 dataType: "json",
		 success: function (result) {
		     stacks = result;
		     moves = [];
		     for (var i=0; i < stacks.length; i++) {
			 moves.push({action: "create_stack", params: [stacks[i].name, stacks[i].type,stacks[i].x,stacks[i].y,stacks[i].dif]});
		     }
		     CP.play(moves,10);	 
		     CP.get_table_data();
		 },
		 error: function (){
		     window.alert("something wrong!");
		 }});
	 },
	 get_table_data: function() {
	     $.ajax({
		 type: "GET",
		 contentType: "application/json; charset=utf-8",
		 url: "/games/1",
		 data : JSON.stringify({what:"all"}),
		 dataType: "json",
		 success: function (result) {
		     moves = [];
		     for (var i=0; i < result.hands.length; i++) {
			 for (var c = 0; c < result.hands[i].length; c++){
			     moves.push({action: "add_card_to_stack", params: ["hand" + i, result.hands[i][c],true]});			     
			 }
		     }
		     for (var i=0; i < result.talon.length; i++){
			     moves.push({action: "add_card_to_stack", params: ["talon", result.talon[i],true]});			     
		     }	 
		     $('#string_rep').html(result.to_s);
		     CP.play(moves,10);	 
		 },
		 error: function (){
		     window.alert("something wrong!");
		 }});
	     	     
	 },	 
	 insert_card_in_stack: function(stack_id,card_id,i){
	     card = Cards.create_card(card_id);	     
	     CP.stacks[stack_id].insert_card(i,card);
	     CP.stacks[stack_id].cards[i].show(this.parent);
	 },
	 add_cards_to_stack: function(stack_id,cards_ids,showstack){
	     for(i=0;i<cards_ids.length; i++){
		 CP.add_card_to_stack(stack_id,cards_ids[i],'card' + cards_ids[i],true);
	     }
	     if (showstack === true ){
		 CP.show_stack(stack_id);
	     }
	 },
	 move_stack: function(stack_id,px,py){
	     CP.stacks[stack_id].move_to(px,py);
	 }
     };
 }());


$(document).ready(function(){
     var ele = $("#cardtable");
     var table = CP.create_table(ele,5);
//     CP.get_table_data();
    CP.get_stacks();

});
