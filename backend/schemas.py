from pydantic import BaseModel, Field
from typing import Optional
from datetime import date
from models import TaskStatus


class TaskBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=200)
    description: Optional[str] = ""
    due_date: date
    status: TaskStatus = TaskStatus.todo
    blocked_by_id: Optional[int] = None


class TaskCreate(TaskBase):
    pass


class TaskUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=200)
    description: Optional[str] = None
    due_date: Optional[date] = None
    status: Optional[TaskStatus] = None
    blocked_by_id: Optional[int] = None


class BlockedByInfo(BaseModel):
    id: int
    title: str
    status: TaskStatus

    class Config:
        from_attributes = True


class TaskResponse(TaskBase):
    id: int
    blocked_by: Optional[BlockedByInfo] = None

    class Config:
        from_attributes = True


class TaskListResponse(BaseModel):
    tasks: list[TaskResponse]
    total: int
