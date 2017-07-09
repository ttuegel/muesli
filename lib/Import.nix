default: f: args:

let
  fn = if builtins.isFunction f then f else import f;
  auto = builtins.intersectAttrs (builtins.functionArgs fn) default;
  overridable = fn: args:
    let
      applied = fn args;
      override = { Import.override = over: overridable fn (args // over); };
    in
      if builtins.isAttrs applied
      then applied // override
      else if builtins.isFunction applied
      then { __functor = self: applied; } // override
      else applied;
in
overridable fn (auto // args)
