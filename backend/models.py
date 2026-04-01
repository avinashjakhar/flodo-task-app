from sqlalchemy import Column, Integer, String, Date, ForeignKey, Enum as SAEnum
from sqlalchemy.orm import relationship
import enum
from database import Base


class TaskStatus(str, enum.Enum):
    todo = "To-Do"
    in_progress = "In Progress"
    done = "Done"


class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False, index=True)
    description = Column(String, nullable=True, default="")
    due_date = Column(Date, nullable=False)
    status = Column(SAEnum(TaskStatus), nullable=False, default=TaskStatus.todo)
    blocked_by_id = Column(Integer, ForeignKey("tasks.id"), nullable=True)

    blocked_by = relationship("Task", remote_side=[id], foreign_keys=[blocked_by_id])
