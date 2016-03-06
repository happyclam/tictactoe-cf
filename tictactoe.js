// Generated by CoffeeScript 1.10.0
(function() {
  var Board, Const, Game, Player,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  $(function() {
    var Tictactoe;
    return Tictactoe = new Game;
  });

  Const = (function() {
    function Const() {}

    Const.NOUGHT = 1;

    Const.CROSS = -1;

    Const.DRAW = 0;

    Const.MAX_VALUE = 9;

    Const.MIN_VALUE = -9;

    Const.LIMIT = 6;

    Const.WIDTH = 300;

    Const.HEIGHT = 300;

    Const.RADIUS = 50;

    Const.PART = 100;

    return Const;

  })();

  Board = (function(superClass) {
    var drawanimation;

    extend(Board, superClass);

    function Board(args) {
      this.animate = bind(this.animate, this);
      var i, j, ref;
      for (i = j = 0, ref = args.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        this.push(args[i]);
      }
      this.canvas = document.getElementById("canvasMain");
      this.canvas.width = Const.WIDTH;
      this.canvas.height = Const.HEIGHT;
      this.lineno = null;
      this.lines = [];
      this.lines.push([0, 1, 2]);
      this.lines.push([3, 4, 5]);
      this.lines.push([6, 7, 8]);
      this.lines.push([0, 3, 6]);
      this.lines.push([1, 4, 7]);
      this.lines.push([2, 5, 8]);
      this.lines.push([0, 4, 8]);
      this.lines.push([2, 4, 6]);
      this.weight = [1, 0, 1, 0, 2, 0, 1, 0, 1];
      this.start = {
        y: 0,
        x: 0
      };
      this.end = {
        y: 220,
        x: 100
      };
      this.request = null;
      this.amount = 0;
    }

    Board.prototype.init = function() {
      var i, j, ref;
      this.lineno = null;
      for (i = j = 0, ref = this.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        this[i] = null;
      }
      return this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
    };

    Board.prototype.animate = function() {
      this.request = requestAnimFrame(this.animate, this.canvas);
      return drawanimation.call(this);
    };

    drawanimation = function() {
      var newX, newY;
      this.context = this.canvas.getContext('2d');
      this.amount += 0.02;
      if (this.amount > 1) {
        this.amount = 1;
      }
      switch (this.lineno) {
        case 0:
          this.start.x = 25;
          this.start.y = Const.PART - 50;
          this.end.x = Const.WIDTH - 25;
          this.end.y = Const.PART - 50;
          break;
        case 1:
          this.start.x = 25;
          this.start.y = Const.PART * 2 - 50;
          this.end.x = Const.WIDTH - 25;
          this.end.y = Const.PART * 2 - 50;
          break;
        case 2:
          this.start.x = 25;
          this.start.y = Const.PART * 3 - 50;
          this.end.x = Const.WIDTH - 25;
          this.end.y = Const.PART * 3 - 50;
          break;
        case 3:
          this.start.x = Const.PART - 50;
          this.start.y = 25;
          this.end.x = Const.PART - 50;
          this.end.y = Const.HEIGHT - 25;
          break;
        case 4:
          this.start.x = Const.PART * 2 - 50;
          this.start.y = 25;
          this.end.x = Const.PART * 2 - 50;
          this.end.y = Const.HEIGHT - 25;
          break;
        case 5:
          this.start.x = Const.PART * 3 - 50;
          this.start.y = 25;
          this.end.x = Const.PART * 3 - 50;
          this.end.y = Const.HEIGHT - 25;
          break;
        case 6:
          this.start.x = 25;
          this.start.y = 25;
          this.end.x = Const.WIDTH - 25;
          this.end.y = Const.HEIGHT - 25;
          break;
        case 7:
          this.start.x = 25;
          this.start.y = Const.HEIGHT - 25;
          this.end.x = Const.WIDTH - 25;
          this.end.y = 25;
      }
      this.context.beginPath();
      this.context.moveTo(this.start.x, this.start.y);
      this.context.strokeStyle = 'rgba(255, 105, 180, 0.2)';
      this.context.lineWidth = 12;
      newX = this.start.x + (this.end.x - this.start.x) * this.amount;
      newY = this.start.y + (this.end.y - this.start.y) * this.amount;
      this.context.lineTo(newX, newY);
      this.context.stroke();
      if (newX === this.end.x && newY === this.end.y) {
        cancelRequestAnimFrame(this.request);
        this.request = null;
        return this.amount = 0;
      }
    };

    Board.prototype.display = function() {
      var i, j, ref, x, y;
      this.context = this.canvas.getContext('2d');
      this.context.beginPath();
      this.context.fillStyle = "#2f4f4f";
      this.context.fillRect(0, 0, this.canvas.width, this.canvas.height);
      this.context.strokeStyle = "rgb(255, 255, 255)";
      this.context.lineWidth = 5;
      this.context.moveTo(Const.PART, 0);
      this.context.lineTo(Const.PART, Const.HEIGHT);
      this.context.moveTo(Const.PART * 2, 0);
      this.context.lineTo(Const.PART * 2, Const.HEIGHT);
      this.context.moveTo(0, Const.PART);
      this.context.lineTo(Const.WIDTH, Const.PART);
      this.context.moveTo(0, Const.PART * 2);
      this.context.lineTo(Const.WIDTH, Const.PART * 2);
      for (i = j = 0, ref = this.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        x = Const.PART * (i % 3);
        y = Const.PART * Math.floor(i / 3);
        if (this[i] === Const.NOUGHT) {
          this.context.moveTo(x + Const.PART, y + Const.RADIUS);
          this.context.arc(x + Const.RADIUS, y + Const.RADIUS, Const.RADIUS, 0, Math.PI * 2, false);
        } else if (this[i] === Const.CROSS) {
          this.context.moveTo(x, y);
          this.context.lineTo(x + Const.PART, y + Const.PART);
          this.context.moveTo(x + Const.PART, y);
          this.context.lineTo(x, y + Const.PART);
        }
      }
      return this.context.stroke();
    };

    Board.prototype.wonorlost = function() {
      var i, j, len, line, piece, ref;
      ref = this.lines;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        line = ref[i];
        piece = this[line[0]];
        if (piece && piece === this[line[1]] && piece === this[line[2]]) {
          this.lineno = i;
          return piece;
        }
      }
      if (indexOf.call(this, null) >= 0) {
        return null;
      }
      return 0;
    };

    return Board;

  })(Array);

  Player = (function() {
    function Player(sengo) {
      this.sengo = sengo != null ? sengo : Const.CROSS;
    }

    Player.prototype.byweight = function(board) {
      var b, cross, i, j, len, nought;
      cross = 0;
      nought = 0;
      for (i = j = 0, len = board.length; j < len; i = ++j) {
        b = board[i];
        if (b === Const.CROSS) {
          cross += board.weight[i];
        } else if (b === Const.NOUGHT) {
          nought += board.weight[i];
        }
      }
      return cross - nought;
    };

    Player.prototype.byline = function(board) {
      var ret;
      return ret = (function() {
        switch (board.wonorlost()) {
          case Const.NOUGHT:
            return Const.MIN_VALUE;
          case Const.CROSS:
            return Const.MAX_VALUE;
          case Const.DRAW:
            return 0;
          default:
            return 0;
        }
      })();
    };

    Player.prototype.lookahead = function(board, evaluation, turn, cnt, threshold) {
      var b, i, j, len, locate, ret, teban, temp_v, value;
      if (turn === Const.CROSS) {
        value = Const.MIN_VALUE;
      } else {
        value = Const.MAX_VALUE;
      }
      locate = null;
      for (i = j = 0, len = board.length; j < len; i = ++j) {
        b = board[i];
        if (b === null) {
          board[i] = turn;
          if (cnt < Const.LIMIT && board.wonorlost() === null) {
            teban = (turn === Const.NOUGHT ? Const.CROSS : Const.NOUGHT);
            ret = this.lookahead(board, evaluation, teban, cnt + 1, value);
            temp_v = ret.value;
          } else {
            temp_v = evaluation(board);
          }
          board[i] = null;
          if (temp_v >= value && turn === Const.CROSS) {
            value = temp_v;
            locate = i;
            if (threshold < temp_v) {
              break;
            }
          } else if (temp_v <= value && turn === Const.NOUGHT) {
            value = temp_v;
            locate = i;
            if (threshold > temp_v) {
              break;
            }
          }
        }
      }
      return {
        locate: locate,
        value: value
      };
    };

    return Player;

  })();

  Game = (function() {
    function Game() {
      this.board = new Board([null, null, null, null, null, null, null, null, null]);
      this.playing = false;
      this.man_player = new Player(Const.CROSS);
      this.cpu_player = new Player(Const.NOUGHT);
      this.orders = document.getElementsByName("optOrders");
      this.startbtn = document.getElementById("btnStart");
      this.statusarea = document.getElementById("spanStatus");
      this.setEventListener();
      this.board.display();
      this.status = null;
    }

    Game.prototype.btnstart = function(target) {
      var ret, threshold;
      this.board.init();
      if (this.cpu_player.sengo === Const.CROSS) {
        threshold = Const.MAX_VALUE;
        ret = this.cpu_player.lookahead(this.board, this.cpu_player.byweight, this.cpu_player.sengo, 1, threshold);
        this.board[ret.locate] = Const.CROSS;
      }
      this.board.display();
      return this.prepared();
    };

    Game.prototype.optchange = function(target) {
      if (target.context.value === "1") {
        this.man_player.sengo = Const.NOUGHT;
        return this.cpu_player.sengo = Const.CROSS;
      } else {
        this.man_player.sengo = Const.CROSS;
        return this.cpu_player.sengo = Const.NOUGHT;
      }
    };

    Game.prototype.touch = function(target, clientX, clientY) {
      var clickX, clickY, judge, ret, threshold;
      if (this.status == null) {
        return;
      }
      clickX = Math.floor((clientX - target[0].offsetLeft) / Const.PART);
      clickY = Math.floor((clientY - target[0].offsetTop) / Const.PART);
      if (this.board[clickX + clickY * 3] !== null) {
        return;
      }
      this.board[clickX + clickY * 3] = this.man_player.sengo;
      judge = this.board.wonorlost();
      if (judge != null) {
        this.gameover(judge);
      } else {
        threshold = this.cpu_player.sengo === Const.CROSS ? Const.MAX_VALUE : Const.MIN_VALUE;
        ret = this.cpu_player.lookahead(this.board, this.cpu_player.byline, this.cpu_player.sengo, 1, threshold);
        this.board[ret.locate] = this.cpu_player.sengo;
        judge = this.board.wonorlost();
        if (judge != null) {
          this.gameover(judge);
        }
      }
      return this.board.display();
    };

    Game.prototype.setEventListener = function() {
      $('#optOrder1').on('change', (function(_this) {
        return function(e) {
          var target;
          target = $(e.currentTarget);
          return _this.optchange(target);
        };
      })(this));
      $('#optOrder2').on('change', (function(_this) {
        return function(e) {
          var target;
          target = $(e.currentTarget);
          return _this.optchange(target);
        };
      })(this));
      $('#canvasMain').on('click', (function(_this) {
        return function(e) {
          var target;
          target = $(e.currentTarget);
          return _this.touch(target, e.clientX, e.clientY);
        };
      })(this));
      return $('#btnStart').on('click', (function(_this) {
        return function(e) {
          var target;
          target = $(e.currentTarget);
          return _this.btnstart(target);
        };
      })(this));
    };

    Game.prototype.gameover = function(winner) {
      var j, len, msg, opt, ref;
      this.status = null;
      ref = this.orders;
      for (j = 0, len = ref.length; j < len; j++) {
        opt = ref[j];
        opt.disabled = false;
      }
      this.startbtn.disabled = false;
      msg = (function() {
        switch (winner) {
          case Const.CROSS:
            return "×の勝ち";
          case Const.NOUGHT:
            return "◯の勝ち";
          case Const.DRAW:
            return "引き分け";
          default:
            return "";
        }
      })();
      this.statusarea.innerHTML = msg;
      if (winner !== 0) {
        return this.board.animate();
      }
    };

    Game.prototype.prepared = function() {
      var j, len, opt, ref;
      this.status = true;
      ref = this.orders;
      for (j = 0, len = ref.length; j < len; j++) {
        opt = ref[j];
        opt.disabled = true;
      }
      this.startbtn.disabled = true;
      return this.statusarea.innerHTML = "";
    };

    return Game;

  })();

  window.Game = window.Game || Game;

  window.requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();

  window.cancelRequestAnimFrame = (function() {
    return window.cancelAnimationFrame || window.webkitCancelRequestAnimationFrame || window.mozCancelRequestAnimationFrame || window.oCancelRequestAnimationFrame || window.msCancelRequestAnimationFrame || clearTimeout;
  })();

}).call(this);
