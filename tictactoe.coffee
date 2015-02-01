#-*- coding: utf-8 -*-
#NOUGHT = -1
#CROSS = 1
#DRAW = 0
#MAX_VALUE = 9
#MIN_VALUE = -9
#LIMIT = 9
#$ = jQuery
$ ->

 Tictactoe = new Game
 FastClick.attach document.body
 return
 
class Const
    @NOUGHT = 1
    @CROSS = -1
    @DRAW = 0
    @MAX_VALUE = 9
    @MIN_VALUE = -9
    @LIMIT = 6

class Board extends Array
#    constructor: (args...) ->
    constructor: (args) ->
#        super(args...)
        @.push(args[i]) for i in [0...args.length]
        @canvas = document.getElementById("canvasMain")
        @canvas.width = 600
        @canvas.height = 600
        @lines = []
        @lines.push([0, 1, 2])
        @lines.push([3, 4, 5])
        @lines.push([6, 7, 8])
        @lines.push([0, 3, 6])
        @lines.push([1, 4, 7])
        @lines.push([2, 5, 8])
        @lines.push([0, 4, 8])
        @lines.push([2, 4, 6])
        @weight = [1, 0, 1, 0, 2, 0, 1, 0, 1]
        
    clone: =>
        buf = new Array(@.length)
        for temp, i in @
            buf[i] = temp

    init: =>
        @[i] = null for i in [0...@.length]
        @context.clearRect(0, 0, @canvas.width, @canvas.height)

    display: =>
        @context = @canvas.getContext('2d')
        @context.beginPath()
        @context.fillStyle = "#ffffff"
        @context.strokeStyle = "#000000"
        @context.lineWidth = 3
        @context.moveTo(200, 0); @context.lineTo(200, 600)
        @context.moveTo(400, 0); @context.lineTo(400, 600)
        @context.moveTo(0, 200); @context.lineTo(600, 200)
        @context.moveTo(0, 400); @context.lineTo(600, 400)
        for i in [0...@.length]
            x = (200 * (i % 3))
            y = (200 * Math.floor(i / 3))
            if @[i] == Const.NOUGHT
                @context.moveTo(x + 200, y + 100)
                @context.arc(x + 100, y + 100, 100, 0, Math.PI * 2, false)
            else if @[i] == Const.CROSS
                @context.moveTo(x, y); @context.lineTo(x + 200, y + 200)
                @context.moveTo(x + 200, y); @context.lineTo(x, y + 200)
        @context.stroke()

    wonorlost: =>
        for line in @.lines
            piece = @[line[0]]
            if (piece && piece == @[line[1]] && piece == @[line[2]])
                return piece
        return null if null in @
        0

class Player
    constructor: (@sengo = Const.CROSS) ->
        console.log(@sengo)

    check: (board) =>
        for line in board.lines
            piece = board[line[0]]
            if (piece && piece == board[line[1]] && piece == board[line[2]])
                return true
        false

    evaluation: (board) =>
        ret = switch board.wonorlost()
            when Const.NOUGHT then Const.MIN_VALUE
            when Const.CROSS then Const.MAX_VALUE
            when Const.DRAW then 0
            else 0
                    
    lookahead: (board, turn, cnt, threshold) =>
#        if cnt >= Const.LIMIT
#            return locate: null, value: @evaluation(board)
        if turn == Const.CROSS
            value = Const.MIN_VALUE
        else
            value = Const.MAX_VALUE

        locate = null
        for b,i in board
            if b == null
                board[i] = turn
                if cnt < Const.LIMIT && board.wonorlost() == null
                    teban = (if turn == Const.NOUGHT then Const.CROSS else Const.NOUGHT)
                    ret = @lookahead(board, teban, cnt + 1, value)
                    temp_v = ret.value
                else
                    temp_v = @evaluation(board)
                
                board[i] = null
                if (temp_v >= value && turn == Const.CROSS)
                    value = temp_v
                    locate = i
                    break if threshold < temp_v
                else if (temp_v <= value && turn == Const.NOUGHT)
                    value = temp_v
                    locate = i
                    break if threshold > temp_v
        return locate: locate, value: value
        
class Game
    constructor: ->
        @board = new Board([null, null, null, null, null, null, null, null, null])
        @playing = false
        @man_player = new Player(Const.CROSS)
        @cpu_player = new Player(Const.NOUGHT)
        @orders = document.getElementsByName("optOrders")
        @startbtn = document.getElementById("btnStart")
        @statusarea = document.getElementById("spanStatus")        
        @setEventListener()
        @board.display()
        @status = null
                    
    btnstart: (target) =>
        console.log("game.btnstart")
        @board.init()
        if @cpu_player.sengo == Const.CROSS
            threshold = Const.MAX_VALUE
            ret = @cpu_player.lookahead(@board, @cpu_player.sengo, 1, threshold)            
            console.log(ret)
            @board[ret.locate] = Const.CROSS
        @board.display()        
        @prepared()

    optchange: (target) =>
        console.log("game.optchange")
        if target.context.value == "1"
            @man_player.sengo = Const.NOUGHT
            @cpu_player.sengo = Const.CROSS
        else
            @man_player.sengo = Const.CROSS
            @cpu_player.sengo = Const.NOUGHT
        console.log(@man_player.sengo)
        console.log(@cpu_player.sengo)
        
    touch: (target, clientX, clientY) =>
        console.log("game.touch")
        console.log(@status) 
        unless @status? then console.log("cancel"); return
        clickX = Math.floor((clientX - target[0].offsetLeft) / 200)
        clickY = Math.floor((clientY - target[0].offsetTop) / 200)
        unless @board[clickX + clickY * 3] == null then console.log("not null"); return
        @board[clickX + clickY * 3] = @man_player.sengo
        judge = @board.wonorlost()
        console.log("judge=" + judge.toString()) if judge != null
        if judge != null
            @gameover(judge)
        else
            threshold = if @cpu_player.sengo == Const.CROSS then Const.MAX_VALUE else Const.MIN_VALUE
            ret = @cpu_player.lookahead(@board, @cpu_player.sengo, 1, threshold)               
            console.log(ret)
            @board[ret.locate] = @cpu_player.sengo
            judge = @board.wonorlost()
            @gameover(judge) if judge != null
        @board.display()
            
    setEventListener: =>
        $('#optOrder1').on 'change', (e) =>
            target = $(e.currentTarget)
            @optchange(target)

        $('#optOrder2').on 'change', (e) =>
            target = $(e.currentTarget)
            @optchange(target)

        $('#canvasMain').on 'click', (e) =>
            target = $(e.currentTarget)
            @touch(target, e.clientX, e.clientY)

        $('#btnStart').on 'click', (e) =>
            target = $(e.currentTarget)
            @btnstart(target)
            
    gameover: (winorless) =>
        console.log("game.gameover")
        @status = null
        for opt in @orders
            opt.disabled = false
        @startbtn.disabled = false
        console.log(@statusarea)
        msg = switch winorless
            when Const.CROSS then "×の勝ち"
            when Const.NOUGHT then "◯の勝ち"
            when Const.DRAW then "引き分け"
            else ""
        @statusarea.innerHTML = msg
                
    prepared: =>
        console.log("game.prepared")
        @status = true
        for opt in @orders
            opt.disabled = true
        @startbtn.disabled = true
        @statusarea.innerHTML = ""

window.Game = window.Game || Game
    
