#!/bin/bash

TODO_FILE="$HOME/todo/tasks.txt"

# 确保待办事项目录存在
mkdir -p "$HOME/todo"

# 如果文件不存在，创建它
if [ ! -f "$TODO_FILE" ]; then
    touch "$TODO_FILE"
fi

case "$1" in
    "add"|"a")
        shift
        # 添加新待办事项
        echo "● $*" >> "$TODO_FILE"
        echo "已添加：$*"
        ;;
    "done"|"d")
        shift
        # 将待办事项标记为已完成
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            LINE_NUM=$1
            TOTAL_LINES=$(wc -l < "$TODO_FILE")
            
            if [ "$LINE_NUM" -le "$TOTAL_LINES" ] && [ "$LINE_NUM" -gt 0 ]; then
                TASK=$(sed "${LINE_NUM}q;d" "$TODO_FILE")
                # 简单替换标记
                NEW_TASK=$(echo "$TASK" | sed 's/●/✓/')
                sed -i "${LINE_NUM}s/.*/$NEW_TASK/" "$TODO_FILE"
                echo "已完成：${TASK//●/}"
            else
                echo "错误：行号 $LINE_NUM 超出范围（1-$TOTAL_LINES）"
            fi
        else
            echo "错误：请提供有效的行号"
        fi
        ;;
    "list"|"l")
        # 显示待办事项列表（带行号）
        nl -w2 -s". " "$TODO_FILE"
        ;;
    "clear"|"c")
        # 清除已完成的待办事项
        grep -v "✓" "$TODO_FILE" > "$TODO_FILE.tmp"
        mv "$TODO_FILE.tmp" "$TODO_FILE"
        echo "已清除所有已完成项目"
        ;;
    "edit"|"e")
        # 使用编辑器编辑待办事项文件
        if [ -n "$EDITOR" ]; then
            $EDITOR "$TODO_FILE"
        else
            xdg-open "$TODO_FILE"  # 使用默认文本编辑器
        fi
        ;;
    *)
        echo "用法："
        echo "  todo.sh add|a [任务]   - 添加新待办事项"
        echo "  todo.sh done|d [行号]  - 将待办事项标记为已完成"
        echo "  todo.sh list|l         - 显示所有待办事项（带行号）"
        echo "  todo.sh clear|c        - 清除所有已完成的项目"
        echo "  todo.sh edit|e         - 编辑待办事项文件"
        ;;
esac
