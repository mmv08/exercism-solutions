defmodule Zipper do
  defstruct [:focus, :trail]

  @type trail :: [{:left | :right, any, BinTree.t()}]
  @type t :: %Zipper{focus: BinTree.t(), trail: trail}

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{focus: bin_tree, trail: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%{focus: tree, trail: []}), do: tree
  def to_tree(zipper), do: zipper |> up |> to_tree()

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper) do
    zipper.focus.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{focus: focus_node, trail: trail}) do
    case focus_node.left do
      nil ->
        nil

      _ ->
        %Zipper{
          focus: focus_node.left,
          trail: [{:left, focus_node.value, focus_node.right}] ++ trail
        }
    end
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{focus: focus_node, trail: trail}) do
    case focus_node.right do
      nil ->
        nil

      _ ->
        %Zipper{
          focus: focus_node.right,
          trail: [{:right, focus_node.value, focus_node.left}] ++ trail
        }
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{focus: _tree, trail: []}), do: nil

  def up(%Zipper{focus: tree, trail: [{dir, value, path} | tail]}) do
    case dir do
      :right ->
        %Zipper{focus: %BinTree{value: value, left: path, right: tree}, trail: tail}

      :left ->
        %Zipper{focus: %BinTree{value: value, left: tree, right: path}, trail: tail}
    end
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    %Zipper{zipper | focus: %{zipper.focus | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    %Zipper{zipper | focus: %{zipper.focus | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    %Zipper{zipper | focus: %{zipper.focus | right: right}}
  end
end
