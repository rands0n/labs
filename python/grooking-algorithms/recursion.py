def look_for_key(main_box):
  pile = main_box.make_a_pile_to_look_through()

  while pile is not empty:
    box = pile.grab_a_box()

    for item in box:
      if item.is_a_box():
        pile.append(item)
      elif item.is_a_key():
        print "found the key!"

def look_for_key(box):
  for item in box:
    if item.is_a_box():
      look_for_key(item) # recursion!
    elif item.is_a_key:
      print 'found the key!'

def countdown(i):
  print i

  if i <= 0:
    return
  else:
    countdown(i - 1)

countdown(10)

def fact(x):
  print x

  if x == 1:
    return 1
  else:
    return x * fact(x - 1)

fact(3)