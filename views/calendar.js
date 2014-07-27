(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View.Calendar = (function(_super) {
    __extends(Calendar, _super);

    function Calendar() {
      return Calendar.__super__.constructor.apply(this, arguments);
    }

    Calendar.prototype.el = '.content';

    Calendar.prototype.template = _.template($('#calendar').html());

    Calendar.prototype.render = function() {
      var content, first_date, i, last_date, mominst, row, rows, _i;
      rows = [];
      mominst = moment().startOf('month');
      first_date = mominst.clone().startOf('month');
      last_date = mominst.clone().endOf('month');
      mominst.day(0);
      while (true) {
        row = {
          title: mominst.format('w'),
          cols: []
        };
        for (i = _i = 0; _i <= 6; i = ++_i) {
          row.cols.push({
            value: mominst.format('D'),
            attributes: {
              stamp: mominst.format('X'),
              month: mominst.month()
            }
          });
          mominst.add(1, 'day');
        }
        rows.push(row);
        if (mominst.isAfter(last_date)) {
          break;
        }
      }
      content = this.template({
        rows: rows,
        title: first_date.format('MMMM'),
        month: first_date.month()
      });
      return this.$el.html(content);
    };

    return Calendar;

  })(Backbone.View);

}).call(this);
