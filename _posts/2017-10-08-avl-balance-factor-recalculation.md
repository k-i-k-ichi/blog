---
layout: post
title: "Calculate balance factor when rotating AVL tree node"
date: 2017-10-08 12:00:00
categories: algorithms
featured_image: /images/lewis.jpg
---

In AVL tree, we keep track of the tree's balance using a balance factor number, updated with every insertion and deletion. This is an attempt to factorize the recalculation process inside during rotation, instead of insertion / deletion. Doing so would tidy up the code significantly.

## AVL tree

AVL tree is the first type of self-balancing binary search tree invented, if you are missing out on BST you can read more in [ here ][1].

Still, AVL tree definition are simple enough: for any node, the height of the subtree of the left child and the height of the subtree of the right child does not differ by more than 1. And height is defined as the longest path from the root to leaf node.

The height of any AVL tree and worst case complexity of searches, is bounded by $$ O(\log n) $$. At time of insertions and deletions, violations to the property of AVL tree can happen, both AVL tree and red-black tree adopt a procedure called **rotation** to restore the balance.

## Balance factor

To enforce the tree property, at each node we store a balance factor ```int bfact``` over the range.
<center> $$ \{ -2, -1, 0, 1, 2 \} $$</center>

Which denote the height of the right minus the height of the left subtree of that node


{% highlight c %}
struct avlTree{
  avlNode* root;
};

struct avlNode {
  struct avlNode* parent = NULL;
  struct avlNode* left = NULL;
  struct avlNode* right = NULL;
  int key;
  int bfact = 0;
};
{% endhighlight %}

## Rotation

After insert any node, the balance factor of the new node's parent can either decrease or increase, the balance factor is update throughout the tree up until the root.
When a node have a balance factor of 2 or -2, rotations can help rebalance the tree. You can get a much more detailed explaination [here][2]

What we have here is the general case of left rotation, keep in mind that A, B and G denote a subtree of any heigh ( including 0 in which case they will be NULL). While X and Y are a node

![Before]({{ "/assets/avl.jpg" | absolute_url }})

After a left rotation, the balance factor changed for both X and Y, and we wish to carry out update on these value, without the overhead of recalculating the height of any subtree A, B or G ( since only the balance factor is stored inside a node, calculating the height of subtree require depth traversal)

![After]({{ "/assets/avlleft.jpg" | absolute_url }})

We use the below notation for our calculation

$$ B(n) : \text{Balance factor of node n before rotation} $$

$$ b(n) : \text{Balance factor of node n after rotation} $$

$$ H(n) : \text{Height of subtree at node n, before rotation} $$

$$ h(n) : \text{Height of subtree at node n, after rotation} $$

$$ \text{ Note that for nodes A, B, C the height of their subtree and their balance factor does not change } $$

**First we calculate balance factor of X after rotation:**

$$ b(X) = H(B) - H(A) $$

We can calculate H(B) based off of H(Y), consider that the height of Y is depedent on the height of the higher children.

$$ H(Y) =
\begin{cases}
	H(B) + 1, & \text{if } B(Y) \leqslant 0\\
	H(G) + 1, & \text{if } B(Y) > 0
\end{cases}
\\

\Longleftrightarrow
\begin{cases}
	H(B) = H(Y) - 1, & \text{if } B(Y) \leqslant 0\\
	H(Y) = H(B) + B(Y) + 1, & \text{if } B(Y) > 0
\end{cases}
\\

\Longleftrightarrow H(B) =
\begin{cases}
	H(Y) - 1, & \text{if } B(Y) \leqslant 0 \\
	H(Y) - B(Y) - 1, & \text{if } B(Y) > 0
\end{cases}
\\

\Longleftrightarrow H(B) - H(A) =
\begin{cases}
	H(Y) - H(A) - 1, & \text{if } B(Y) \leqslant 0 \\
	H(Y) - H(A) - B(Y) - 1, & \text{if } B(Y) > 0
\end{cases}
$$

Finally, substitute the equation of the initial balance factor for X: $$ B(X) = H(Y) - H(A) $$

$$
b(X) =
\begin{cases}
	B(X) - 1,				& \text{if } \quad B(Y) \leqslant 0 \\
	B(X) - B(Y) - 1,	& \text{if } \quad B(Y) > 0
\end{cases}
$$

**Now consider the balance factor of Y after rotation**

$$ b(Y) = H(G) - H(X) =
\begin{cases}
 	H(G) - ( H(B) + 1 ), & \text{if } \quad b(X) \geqslant 0 \\
 	H(G) - ( H(A) + 1 ), & \text{if } \quad b(X) < 0
\end{cases}
$$

If you immediately notice it, then $$ H(G) - H(B) = B(Y) $$, then we have our easy case:

$$ b(Y) = B(Y) - 1 \Longleftrightarrow b(X) \geqslant 0 $$

You could think of this as the subtree at B added 1 extra node X, so the balance of Y shift left by 1

For the case $$ b(Y) = H(G) - H(A) - 1 $$, consider the state of the tree before rotation (note that the height of A, B, C never changed)

$$
H(G) = B(Y) + H(B) \text{(regardless of the value of B(Y))} \\
\therefore b(Y) = H(G) - H(A) - 1 = B(Y) + H(B) - H(A) - 1 = B(Y) + (H(B) - H(A)) - 1 = B(Y) + b(X) - 1
$$

To sum it up:

$$ b(Y) =
\begin{cases}
	B(Y) - 1,& \text{if } \quad b(X) \geqslant 0 \\
	B(Y) + b(X) - 1,& \text{if } \quad b(x) < 0
\end{cases}
$$

The right rotation is pretty much the same, but with a few signs swapped around since they are mirrored.

## Code
Below is the C++ implementations of left and right rotation using pointers, balance factor of X and Y are updated before pointers are moved around.

{%highlight c %}
void rotateLeft(avlTree* tree, avlNode* x){
  avlNode* y = x->right;
  avlNode* p = x->parent;
  if( y!= NULL){
    // Only the balance factor of X and Y is affected
    int old_x_bfact = x->bfact;
    int old_y_bfact = y->bfact;
    //Calculate X bfact
    if(old_y_bfact <= 0){
      x->bfact = old_x_bfact - 1;
    }
    else if (old_y_bfact > 0){
      x->bfact = old_x_bfact - old_y_bfact - 1;
    }

    //Calculate y bfact
    if( x->bfact >= 0){
      y->bfact = old_y_bfact - 1;
    }
    else {
      y->bfact = old_y_bfact + x->bfact - 1;
    }

    x->right = y->left;
    if (y->left != NULL){
      y->left->parent = x;
    }
    y->parent = p;
    if (p != NULL){
      if (x == p->left ){
        p->left = y;
      }
      else if(x == p->right ){
        p->right = y;
      }
    }
    else if (p == NULL){
      tree->root = y;
    }
    y->left = x;
    x->parent = y;
  }
}

void rotateRight(avlTree* tree, avlNode* y){
  avlNode* x = y->left;
  avlNode* p = y->parent;
  if (x != NULL){
    int old_x_bfact = x->bfact;
    int old_y_bfact = y->bfact;
    // Calcuating new Y bfact
    if(old_x_bfact >= 0){
      y->bfact = old_y_bfact + 1;
    }
    else {
      y->bfact = old_y_bfact + old_x_bfact + 1;
    }
    // Calcuating new X bfact
    if(y->bfact <= 0){
      x->bfact = old_x_bfact + 1;
    }
    else{
      x->bfact = y->bfact - old_x_bfact + 1;
    }

    y->left = x->right;
    if (x->right != NULL){
      x->right->parent = y;
    }
    x->parent = p;
    if (p != NULL){
      if ( y == p->left){
        p->left = x;
      }
      else if( y == p->right){
        p->right = x;
      }
    }
    else if (p == NULL){
      tree->root = x;
    }
    x->right = y;
    y->parent = x;
  }
}
{% endhighlight %}


### References:

[1]: https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree "Self-balancing BST"
[2]: https://www.tutorialspoint.com/data_structures_algorithms/avl_tree_algorithm.htm "AVL tree procedures"

\[1\]: <https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree >

\[2\]: <https://www.tutorialspoint.com/data_structures_algorithms/avl_tree_algorithm.htm>