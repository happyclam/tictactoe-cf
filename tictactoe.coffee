#-*- coding: utf-8 -*-
$ ->
    
    Tictactoe = new Game(localStorage.getItem("level"))
      
class Const
    @NOUGHT = 1
    @CROSS = -1
    @DRAW = 0
    @MAX_VALUE = 9
    @MIN_VALUE = -9
    @WIDTH = 300
    @HEIGHT = 300
    @RADIUS = 50
    @PART = 100

class Board extends Array
    constructor: (args) ->
        @.push(args[i]) for i in [0...args.length]
        @canvas = document.getElementById("canvasMain")
        @canvas.width = Const.WIDTH
        @canvas.height = Const.HEIGHT
        @lineno = null
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
        @start = {y:0, x:0}
        @end = {y:220, x:100}         
        @request = null
        @amount = 0
        
    clone: =>
        buf = new Array(@.length)
        for temp, i in @
            buf[i] = temp

    init: =>
        @lineno = null
        @[i] = null for i in [0...@.length]
        @context.clearRect(0, 0, @canvas.width, @canvas.height)

    animate: =>
        @request = requestAnimFrame(@animate, @canvas)
        @drawanimation()

    drawanimation: =>
        @context = @canvas.getContext('2d')
        @amount += 0.02
        @amount = 1  if @amount > 1
        switch @lineno
            when 0
                @start.x = 25; @start.y = Const.PART - 50
                @end.x = Const.WIDTH - 25; @end.y = Const.PART - 50
            when 1
                @start.x = 25; @start.y = Const.PART * 2 - 50            
                @end.x = Const.WIDTH - 25; @end.y = Const.PART * 2 - 50
            when 2
                @start.x = 25; @start.y = Const.PART * 3 - 50
                @end.x = Const.WIDTH - 25; @end.y = Const.PART * 3 - 50
            when 3
                @start.x = Const.PART - 50; @start.y = 25
                @end.x = Const.PART - 50; @end.y = Const.HEIGHT - 25
            when 4
                @start.x = Const.PART * 2 - 50; @start.y = 25            
                @end.x = Const.PART * 2 - 50; @end.y = Const.HEIGHT - 25
            when 5
                @start.x = Const.PART * 3 - 50; @start.y = 25            
                @end.x = Const.PART * 3 - 50; @end.y = Const.HEIGHT - 25
            when 6
                @start.x = 25; @start.y = 25            
                @end.x = Const.WIDTH - 25; @end.y = Const.HEIGHT - 25
            when 7
                @start.x = 25; @start.y = Const.HEIGHT - 25            
                @end.x = Const.WIDTH - 25; @end.y = 25
                        
        @context.beginPath()
        @context.moveTo @start.x, @start.y
        @context.strokeStyle = 'rgba(255, 105, 180, 0.2)'
        @context.lineWidth = 12
        newX = @start.x + (@end.x - @start.x) * @amount
        newY = @start.y + (@end.y - @start.y) * @amount
        @context.lineTo newX, newY
        @context.stroke()
        if newX is @end.x and newY is @end.y
            cancelRequestAnimFrame @request
            @request = null
            @amount = 0
        
    display: =>
        @context = @canvas.getContext('2d')
        @context.beginPath()
        @context.fillStyle = "#2f4f4f"
        @context.fillRect(0, 0, @canvas.width, @canvas.height)
        @context.strokeStyle = "rgb(255, 255, 255)"
        @context.lineWidth = 5
        @context.moveTo(Const.PART, 0); @context.lineTo(Const.PART, Const.HEIGHT)
        @context.moveTo(Const.PART * 2, 0); @context.lineTo(Const.PART * 2, Const.HEIGHT)
        @context.moveTo(0, Const.PART); @context.lineTo(Const.WIDTH, Const.PART)
        @context.moveTo(0, Const.PART * 2); @context.lineTo(Const.WIDTH, Const.PART * 2)
        for i in [0...@.length]
            x = (Const.PART * (i % 3))
            y = (Const.PART * Math.floor(i / 3))
            if @[i] == Const.NOUGHT
                @context.moveTo(x + Const.PART, y + Const.RADIUS)
                @context.arc(x + Const.RADIUS, y + Const.RADIUS, Const.RADIUS - 4, 0, Math.PI * 2, false)
            else if @[i] == Const.CROSS
                @context.moveTo(x + 10, y + 10); @context.lineTo(x + Const.PART - 10, y + Const.PART - 10)
                @context.moveTo(x + Const.PART - 10, y + 10); @context.lineTo(x + 10, y + Const.PART - 10)
        @context.stroke()

    drawline: =>
        console.log(@lineno)
        @context = @canvas.getContext('2d')
        @context.beginPath()
        @context.strokeStyle = "red"
        @context.lineWidth = 12
        switch @lineno
            when 0
                @context.moveTo(0 + 25, Const.PART - 50); @context.lineTo(Const.WIDTH - 25, Const.PART - 50)
            when 1
                @context.moveTo(0 + 25, Const.PART * 2 - 50); @context.lineTo(Const.WIDTH - 25, Const.PART * 2 - 50)
            when 2
                @context.moveTo(0 + 25, Const.PART * 3 - 50); @context.lineTo(Const.WIDTH - 25, Const.PART * 3 - 50)
            when 3
                @context.moveTo(Const.PART - 50, 0 + 25); @context.lineTo(Const.PART - 50, Const.HEIGHT - 25)
            when 4
                @context.moveTo(Const.PART * 2 - 50, 0 + 25); @context.lineTo(Const.PART * 2 - 50, Const.HEIGHT - 25)
            when 5
                @context.moveTo(Const.PART * 3 - 50, 0 + 25); @context.lineTo(Const.PART * 3 - 50, Const.HEIGHT - 25)
            when 6
                @context.moveTo(25, 25); @context.lineTo(Const.WIDTH - 25, Const.HEIGHT - 25)
            when 7
                @context.moveTo(25, Const.HEIGHT - 25); @context.lineTo(Const.WIDTH - 25, 25)
        @context.stroke()

    wonorlost: =>
        for line,i in @.lines
            piece = @[line[0]]
            if (piece && piece == @[line[1]] && piece == @[line[2]])
                @lineno = i
                return piece
        return null if null in @
        0

class Player
    constructor: (@sengo = Const.CROSS, @level = "2") ->
        # console.log("Player.Constructor")
        # console.log(@sengo)
        # console.log(@level)
        
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
                    
    lookahead: (board, level, turn, cnt, threshold) =>
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
                if cnt < level && board.wonorlost() == null
                    teban = (if turn == Const.NOUGHT then Const.CROSS else Const.NOUGHT)
                    ret = @lookahead(board, level, teban, cnt + 1, value)
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
    constructor: (@cpulevel = "2")->
        @board = new Board([null, null, null, null, null, null, null, null, null])
        @playing = false
        @man_player = new Player(Const.CROSS)
        @cpu_player = new Player(Const.NOUGHT, @cpulevel)
        @orders = document.getElementsByName("optOrders")
        @startbtn = document.getElementById("btnStart")
        @statusarea = document.getElementById("spanStatus")        
        @setEventListener()
        @board.display()
        @status = null
                    
    btnstart: (target) =>
        @board.init()
        @cpu_player.level = localStorage.getItem("level")
        if @cpu_player.sengo == Const.CROSS
            threshold = Const.MAX_VALUE
#            ret = @cpu_player.lookahead(@board, @cpu_player.level, @cpu_player.sengo, 1, threshold) 
#            @board[ret.locate] = Const.CROSS
#            @board[4] = Const.CROSS
            idx = Math.floor(Math.random() * 9)
            @board[idx] = Const.CROSS
        @board.display()        
        @prepared()

    optchange: (target) =>
        if target.context.value == "1"
            @man_player.sengo = Const.NOUGHT
            @cpu_player.sengo = Const.CROSS
        else
            @man_player.sengo = Const.CROSS
            @cpu_player.sengo = Const.NOUGHT
        # console.log(@man_player.sengo)
        # console.log(@cpu_player.sengo)
        
    touch: (target, clientX, clientY) =>
        unless @status? then console.log("cancel"); return
        clickX = Math.floor((clientX - target[0].offsetLeft) / Const.PART)
        clickY = Math.floor((clientY - target[0].offsetTop) / Const.PART)
        unless @board[clickX + clickY * 3] == null then console.log("not null"); return
        @board[clickX + clickY * 3] = @man_player.sengo
        judge = @board.wonorlost()
        # console.log("judge=" + judge.toString()) if judge != null
        if judge?
            @gameover(judge)
        else
            #CPUが後手でCPUにとっての初手の場合、乱数で指させる
            if (@cpu_player.sengo == Const.NOUGHT) && !(Const.NOUGHT in @board)
                loop
                    idx = [0, 2, 4, 6, 8][Math.floor(Math.random() * 5)]
                    console.log(idx)
                    break unless @board[idx]
                #２手目は真ん中が空いていれば取らないとWリーチ掛けられて必敗
                #最強の時以外は乱数のまま
                if (@board[4] == null) && (@cpu_player.level == "6")
                    @board[4] = @cpu_player.sengo
                else
                    @board[idx] = @cpu_player.sengo                
            else
                threshold = if @cpu_player.sengo == Const.CROSS then Const.MAX_VALUE else Const.MIN_VALUE
                ret = @cpu_player.lookahead(@board, @cpu_player.level, @cpu_player.sengo, 1, threshold)  
                @board[ret.locate] = @cpu_player.sengo
            
            judge = @board.wonorlost()
            @gameover(judge) if judge?
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
            
    gameover: (winner) =>
        @status = null
        for opt in @orders
            opt.disabled = false
        @startbtn.disabled = false
        msg = switch winner
            when Const.CROSS then "×の勝ち"
            when Const.NOUGHT then "◯の勝ち"
            when Const.DRAW then "引き分け"
            else ""
        @statusarea.innerHTML = msg
        console.log("winner="+winner.toString())
        console.log("lineno="+@board.lineno.toString()) if @board.lineno?
#        @board.drawline() if winner != 0
        @board.animate() if winner != 0
                
    prepared: =>
        @status = true
        for opt in @orders
            opt.disabled = true
        @startbtn.disabled = true
        @statusarea.innerHTML = ""

window.Game = window.Game || Game
    
window.requestAnimFrame = (->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback, element) ->
    window.setTimeout callback, 1000 / 60
)()
window.cancelRequestAnimFrame = (->
  window.cancelAnimationFrame or window.webkitCancelRequestAnimationFrame or window.mozCancelRequestAnimationFrame or window.oCancelRequestAnimationFrame or window.msCancelRequestAnimationFrame or clearTimeout
)()
