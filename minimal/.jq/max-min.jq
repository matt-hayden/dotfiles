# return item at max
def max_of(f):
  (map(f) | max) as $mx
  | .[] | select(f == $mx);

# return item at min
def min_of(f):
  (map(f) | min) as $mx
  | .[] | select(f == $mx);
